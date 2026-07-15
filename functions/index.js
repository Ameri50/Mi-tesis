const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");

admin.initializeApp();

// La API key vive como "secret" en Firebase, nunca en el código ni en el cliente.
const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

const SYSTEM_PROMPT = `
Eres el asistente virtual de "Mi-tesis", una tienda de productos Apple para el mercado peruano.
Responde SIEMPRE, sin importar el tipo de mensaje: saludos, preguntas sobre la app, dudas técnicas,
recomendaciones de productos o cualquier otra cosa. Nunca digas que no puedes ayudar con un tema si
es una conversación normal o un saludo.

SOBRE LA APP (úsalo cuando pregunten qué es la app, qué venden, o en qué puedes ayudar):
- Es una tienda online de productos Apple: iPhone, iPad, Mac, Apple Watch y AirPods, con precios en soles (S/).
- Tiene un catálogo amplio con colores, capacidades y precios por modelo.
- Incluye un módulo de "Servicio Técnico Apple": venta de repuestos originales (pantallas, baterías,
  cámaras, puertos de carga, altavoces, etc.) con instalación profesional, garantía y tiempos de reparación estimados.
- El usuario puede agregar productos o repuestos al carrito y pagar dentro de la misma app.

ESTILO DE RESPUESTA:
- Breve y directo (máximo 3-4 párrafos cortos, o menos si es un saludo simple).
- Conversacional y natural, como si hablaras con un amigo.
- Sin copiar-pegar información ni listas largas ni texto formal.
- Con ejemplos concretos cuando sea útil (ej. mencionar un modelo o repuesto real de la tienda).
- En español latino informal pero profesional.
- Si preguntan algo que no tiene que ver con la app (clima, cultura general, etc.), respóndelo igual
  con naturalidad; no rechaces temas fuera de la tienda.
`;

const MODEL = "gemini-2.5-flash";

/**
 * Callable "geminiChat"
 * data: { message: string, history: [{ role: "user"|"model", text: string }] }
 * Devuelve: { text: string }
 *
 * El cliente (la app iOS) llama a esta función en vez de golpear la API de
 * Gemini directamente, así la API key nunca sale del servidor.
 */
exports.geminiChat = onCall(
  { secrets: [GEMINI_API_KEY], region: "us-central1" },
  async (request) => {
    // Requiere usuario autenticado con Firebase Auth (evita abuso anónimo).
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Debes iniciar sesión para usar el chat.");
    }

    const message = (request.data?.message || "").toString().trim();
    if (!message) {
      throw new HttpsError("invalid-argument", "El mensaje no puede estar vacío.");
    }
    if (message.length > 2000) {
      throw new HttpsError("invalid-argument", "El mensaje es demasiado largo.");
    }

    const history = Array.isArray(request.data?.history) ? request.data.history : [];
    const recentHistory = history.slice(-10);

    const contents = recentHistory
      .filter((m) => m && typeof m.text === "string" && (m.role === "user" || m.role === "model"))
      .map((m) => ({ role: m.role, parts: [{ text: m.text }] }));

    contents.push({ role: "user", parts: [{ text: message }] });

    const url = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY.value()}`;

    const body = {
      contents,
      generationConfig: {
        temperature: 0.9,
        maxOutputTokens: 800,
        topP: 0.95,
        topK: 40,
        responseModalities: ["TEXT"],
      },
      safetySettings: [
        { category: "HARM_CATEGORY_HARASSMENT", threshold: "BLOCK_MEDIUM_AND_ABOVE" },
        { category: "HARM_CATEGORY_HATE_SPEECH", threshold: "BLOCK_MEDIUM_AND_ABOVE" },
        { category: "HARM_CATEGORY_SEXUALLY_EXPLICIT", threshold: "BLOCK_MEDIUM_AND_ABOVE" },
        { category: "HARM_CATEGORY_DANGEROUS_CONTENT", threshold: "BLOCK_MEDIUM_AND_ABOVE" },
      ],
      systemInstruction: {
        parts: [{ text: SYSTEM_PROMPT }],
      },
    };

    let response;
    try {
      response = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });
    } catch (err) {
      throw new HttpsError("unavailable", "No se pudo conectar con Gemini.");
    }

    if (!response.ok) {
      const errText = await response.text();
      console.error("Gemini error:", response.status, errText);
      throw new HttpsError("internal", `Gemini respondió con error ${response.status}.`);
    }

    const json = await response.json();
    const text = json?.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!text) {
      throw new HttpsError("internal", "Gemini no devolvió texto.");
    }

    return { text: text.trim() };
  }
);
