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
                                      uint vid [[ vertex_id  ]],
                                      uint iid [[instance_id]]) {

    auto vert = vertices[iid];
    float left = -0.5;
    float right = 0.5;
    float top = 0.5;
    float bottom = -0.5;
//
//    switch (gl_VertexID) {
//        case 0:
//            pos = vec2(left, top);
//            f_tex_pos = tex_left_top;
//            break;
//        case 1:
//            pos = vec2(right, top);
//            f_tex_pos = vec2(tex_right_bottom.x, tex_left_top.y);
//            break;
//        case 2:
//            pos = vec2(left, bottom);
//            f_tex_pos = vec2(tex_left_top.x, tex_right_bottom.y);
//            break;
//        case 3:
//            pos = vec2(right, bottom);
//            f_tex_pos = tex_right_bottom;
//            break;
//    }
//    switch (vid) {
//        case 0:
//            pos = float2(left, top);
//            break;
//        case 1:
//            pos = float2(right, top);
//            break;
//        case 2:
//            pos = float2(left, bottom);
//            break;
//        case 3:
//            pos = float2(right, bottom);
//            break;
//    }


    float2 pos;
    switch (vid) {
        case 0:
        case 3:
            pos = float2(left, bottom);
            break;
        case 1:
        case 5:
            pos = float2(right, top);
            break;
        case 2:
            pos = float2(left, top);
            break;
        case 4:
            pos = float2(right, bottom);
            break;
    }
    VertexOut vOut;
    vOut.position = float4(pos, 0,1);
    vOut.color = vert.color;
    return vOut;
}

fragment float4 rect_frag(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}

