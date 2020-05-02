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
                                      uint vid [[ vertex_id  ]],
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
    return vOut;
}

float sdRoundBox(float2 p, float2 b, float r)
{
    float2 q = abs(p)-b+r;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r;
}

fragment float4 rect_frag(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}

