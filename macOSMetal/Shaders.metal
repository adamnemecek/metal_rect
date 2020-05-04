//
//  Shaders.metal
//  macOSMetal
//
//  Created by Zach Eriksen on 4/30/18.
//  Copyright © 2018 Zach Eriksen. All rights reserved.
//

#include <metal_stdlib>
#include "SharedTypes.h"

using namespace metal;


struct VertexOut {
    float4 position [[ position ]];
    float4 color;
    float width;
    float height;
    float2 center;
    float2 halfSize;
};


vertex VertexOut basic_vertex_function(const device Vertex *vertices [[ buffer(0) ]],
                                       uint vertexID [[ vertex_id  ]]) {
    VertexOut vOut;
    vOut.position = float4(vertices[vertexID].position,1);
    vOut.color = vertices[vertexID].color;
    return vOut;
}

fragment float4 basic_fragment_function(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}

vertex VertexOut rect_vert(const device Rect1 *vertices [[ buffer(0) ]],
                           const device Uniforms *u [[buffer(1)]],
                           uint vid [[ vertex_id ]],
                           uint iid [[instance_id]]) {

    auto vert = vertices[iid];

    float left = vert.x;
    float right = vert.x + vert.w;
    float bottom = vert.y;
    float top = vert.y + vert.h;

    float2 pos;

    switch (vid) {
        case 0:
            pos = float2(right, top);
            break;
        case 1:
            pos = float2(left, top);
            break;
        case 2:
            pos = float2(right, bottom);
            break;
        case 3:
            pos = float2(left, bottom);
            break;
    }

    VertexOut vOut;
    vOut.position = float4(pos, 0,1);
    vOut.color = vert.color;
    vOut.height = u->height;
    vOut.width = u->width;
    float2 size = float2(u->width, u->height);
    float2 clipCenter = float2((left + right) / 2.0, (top + bottom) / 2.0);
    float2 clipHalfSize = float2(vert.w, vert.h) * 0.5;
    vOut.center = (clipCenter * float2(1.0f, -1.0f) + 1.0f) * 0.5 * size;
    vOut.halfSize = clipHalfSize * 0.5f * size;
    return vOut;
}

float sdRoundBox(float2 p, float2 b, float r) {
    float2 q = abs(p) - b + r;
    return min(max(q.x,q.y), 0.0) + length(max(q, 0.0)) - r;
}

//fragment float4 rect_frag(VertexOut vIn [[ stage_in ]]) {
//    float2 b = float2(vIn.width, vIn.height);
//    float d = sdRoundBox(vIn.position.xy, b, 5.0);
//    float blend = smoothstep(-1.0, 1.0, d);
//    return mix(vIn.color, float4(), blend);
//}

fragment float4 rect_frag(VertexOut vIn [[ stage_in ]]) {
//    float2 b = float2(vIn.width, vIn.height);
//    float aspect = vIn.height / vIn.width;
//    float2 p = float2(vIn.position.x / vIn.width, vIn.position.y / vIn.height);
//    float d = sdRoundBox(p, float2(aspect, 1.0), 0.05);
//    float blend = smoothstep(-1.0, 1.0, d);
//    return mix(vIn.color, float4(), blend);
    float d = sdRoundBox(vIn.position.xy - vIn.center, vIn.halfSize, 25.0f);
    float blend = smoothstep(0.0f, length(fwidth(vIn.position.xy)), d);
    return mix(vIn.color, float4(0, 0, 0, 0), blend);
}
