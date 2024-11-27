shader_type canvas_item;

// Parámetros personalizables
uniform vec4 water_color = vec4(0.0, 0.5, 0.8, 0.5); // Color base del agua (transparente)
uniform vec4 highlight_color = vec4(0.8, 0.9, 1.0, 0.3); // Color de reflejo
uniform float speed = 0.2; // Velocidad del flujo
uniform float wave_amplitude = 0.02; // Amplitud de las ondas
uniform float wave_frequency = 10.0; // Frecuencia de las ondas
uniform float noise_scale = 6.0; // Escala del ruido para distorsión
uniform float highlight_intensity = 0.5; // Intensidad de los reflejos

// Función de ruido simple basado en seno
float simple_noise(vec2 p) {
    return sin(p.x * wave_frequency) * sin(p.y * wave_frequency);
}

// Función para generar ondas
float wave_pattern(vec2 uv, float time_offset) {
    return sin(uv.x * wave_frequency + time_offset) * wave_amplitude
         + cos(uv.y * wave_frequency + time_offset) * wave_amplitude;
}

// Función para generar reflejos dinámicos
float reflection_effect(vec2 uv, float time_offset) {
    vec2 noise_uv = uv * noise_scale + vec2(time_offset * 0.5, time_offset * 0.2);
    return simple_noise(noise_uv);
}

void fragment() {
    vec2 uv = UV; // Coordenadas UV
    float time_offset = TIME * speed;

    // Añadir ondas suaves
    float wave = wave_pattern(uv, time_offset);

    // Crear reflejos dinámicos
    float reflection = reflection_effect(uv, time_offset) * highlight_intensity;

    // Combinar colores para simular agua con reflejos
    vec4 base_color = water_color + vec4(reflection) * highlight_color;

    // Distorsionar el flujo ligeramente
    vec2 distortion_uv = uv + vec2(wave, wave * 0.5);
    vec4 distorted_color = mix(base_color, highlight_color, reflection);

    // Mezclar con el fondo original
    vec4 original_color = texture(TEXTURE, distortion_uv);
    COLOR = mix(original_color, distorted_color, base_color.a);
}
