#version 330
#extension GL_ARB_separate_shader_objects : require

uniform sampler2D InSampler;
uniform sampler2D mapSampler;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
    vec2 mapSize;
};

layout(location = 0) in vec2 texCoord;
layout(location = 0) out vec4 fragColor;

void main() {
    // Original Minecraft screen.
    vec4 scene = texture(InSampler, texCoord);

    // Native pixel dimensions of ready.png.
    vec2 size = mapSize;

    // Center horizontally, position above the hotbar.
    // Increase 0.13 to move the text higher.
    vec2 bottomLeft = vec2(
        0,
        OutSize.y * 0.9
    );

    // Position in screen pixel coordinates.
    vec2 pixel = texCoord * OutSize;
    vec2 p = pixel - bottomLeft;

    // Only draw the PNG inside its rectangular area.
    if (p.x >= 0.0 && p.y >= 0.0 &&
        p.x < size.x && p.y < size.y) {

        vec2 uv = p / size;

        // Convert bottom-origin screen coordinates
        // to the image's top-to-bottom orientation.
        uv.y = 1.0 - uv.y;

        vec4 ready = texture(mapSampler, uv);

        // Blend the transparent text over the world.
        fragColor = vec4(
            mix(scene.rgb, ready.rgb, ready.a),
            scene.a
        );
    } else {
        fragColor = scene;
    }
}