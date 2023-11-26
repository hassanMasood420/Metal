//
//  Shades.metal
//  NewApp
//
//  Created by Umair on 22/11/2023.
//

#include <metal_stdlib>
using namespace metal;


uint2 imageSize(texture2d<float, access::read> texture) {
    return uint2(texture.get_width(), texture.get_height());
}

uint flipY(uint y, uint height) {
    return height - y - 1;
}

kernel void sepiaFilter(
    texture2d<float, access::read> inTexture [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 size = imageSize(inTexture);
    uint flippedY = flipY(gid.y, size.y);

    float4 color = inTexture.read(uint2(gid.x, flippedY));
    float3 sepiaColor = float3(1.2, 1.0, 0.8);
    float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    outTexture.write(float4(mix(color.rgb, gray * sepiaColor, 0.5), color.a), gid);
}

kernel void grayscaleFilter(
    texture2d<float, access::read> inTexture [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 size = imageSize(inTexture);
    uint flippedY = flipY(gid.y, size.y);

    float4 color = inTexture.read(uint2(gid.x, flippedY));
    float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    outTexture.write(float4(gray, gray, gray, color.a), gid);
}

kernel void invertFilter(
    texture2d<float, access::read> inTexture [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 size = imageSize(inTexture);
    uint flippedY = flipY(gid.y, size.y);

    float4 color = inTexture.read(uint2(gid.x, flippedY));
    outTexture.write(float4(1.0 - color.rgb, color.a), gid);
}

kernel void vignetteFilter(
    texture2d<float, access::read> inTexture [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 size = imageSize(inTexture);
    uint flippedY = flipY(gid.y, size.y);

    float2 uv = float2(gid) / float2(size);
    float distance = length(uv - 0.5);
    float vignette = smoothstep(0.7, 0.9, 1.0 - distance);

    float4 color = inTexture.read(uint2(gid.x, flippedY));
    outTexture.write(color * vignette, gid);
}

kernel void goldFilter(
    texture2d<float, access::read> inTexture [[texture(0)]],
    texture2d<float, access::write> outTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint2 size = imageSize(inTexture);
    uint flippedY = flipY(gid.y, size.y);

    float4 color = inTexture.read(uint2(gid.x, flippedY));

    // Apply a gold color effect
    float3 goldColor = float3(1.0, 0.84, 0.0);
    float3 result = color.rgb * goldColor;

    outTexture.write(float4(result, color.a), gid);
}


