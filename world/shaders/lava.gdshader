shader_type canvas_item;

// Parámetros personalizables
uniform vec4 lava_color = vec4(1.0, 0.0, 0.0, 0.5); // Color base de la lava (con transparencia)
uniform vec4 glow_color = vec4(1.0, 1.0, 0.2, 1); // Color del brillo
uniform float speed = 0.01; // Velocidad de la animación
uniform float distortion = 0.01; // Intensidad de la distorsión
uniform float glow_intensity = 0.75; // Intensidad del brillo
uniform float noise_scale = 4.0; // Escala del ruido (ajustar según el tamaño del TileMap)
uniform float bubble_size = 0.5; // Tamaño de las burbujas

// Función de ruido simple basado en seno
float simple_noise(vec2 p) {
    return sin(p.x * 10.0) * sin(p.y * 10.0);
}

// Efecto de burbuja
float bubble_effect(vec2 uv, float time_offset) {
    vec2 center = vec2(mod(uv.x * noise_scale + time_offset, 1.0), mod(uv.y * noise_scale, 1.0));
    return exp(-length(center - vec2(0.5)) / bubble_size);
}

void fragment() {
    vec2 uv = UV; // Coordenadas UV de cada celda del TileMap
    float time_offset = TIME * speed;

    // Crear un flujo más vertical con ruido distorsionado
    vec2 distortion_uv = uv + vec2(sin(uv.y * 12.0 + time_offset) * distortion, time_offset * 0.1);
    float noise_value = simple_noise(distortion_uv * noise_scale + time_offset);

    // Añadir efecto de burbujas
    float bubble = bubble_effect(uv, time_offset);
    noise_value = max(noise_value, bubble);

    // Combinar colores para simular lava con brillo
    vec4 base_color = mix(lava_color, glow_color, clamp(noise_value * glow_intensity, 0.0, 1.0));

    // Mezclar con el fondo original
    vec4 original_color = texture(TEXTURE, UV);
    COLOR = mix(original_color, base_color, base_color.a);
}
