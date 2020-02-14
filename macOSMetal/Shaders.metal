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
//    float left = -0.5;
//    float right = 0.5;
//    float top = 0.5;
//    float bottom = -0.5;

    float left = vert.x;
    float right = vert.x + vert.w;
    float bottom = vert.y;
    float top = vert.y + vert.h;
//
    float2 pos0 = float2(left, bottom);
    float2 pos1 = float2(right, top);
    float2 pos2 = float2(left, top);
    float2 pos3 = float2(right, bottom);



    float2 pos;
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

//    {0,1,2,3},
//    {1,0,2,3},
//    {2,0,1,3},
//    {0,2,1,3},
//    {1,2,0,3},
//    {2,1,0,3},
//    {2,1,3,0},
//    {1,2,3,0},
//    {3,2,1,0},
//    {2,3,1,0},
//    {1,3,2,0},
//    {3,1,2,0},
//    {3,0,2,1},
//    {0,3,2,1},

//    {2,3,0,1},
//    {3,2,0,1},
//    {0,2,3,1},
//    {2,0,3,1},

//    {1,0,3,2},
//    {0,1,3,2},

//    {3,1,0,2},
//    {1,3,0,2},
//    {0,3,1,2},
//    {3,0,1,2},
    // this one doesnt'
//    switch (vid) {
//        case 3:
//            pos = pos0;
//            break;
//        case 0:
//            pos = pos1;
//            break;
//        case 1:
//            pos = pos2;
//            break;
//        case 2:
//            pos = pos3;
//            break;
//    }

    /// this approach works
//    switch (vid) {
//        case 0:
//        case 3:
//            pos = float2(left, bottom);
//            break;
//        case 1:
//        case 5:
//            pos = float2(right, top);
//            break;
//        case 2:
//            pos = float2(left, top);
//            break;
//        case 4:
//            pos = float2(right, bottom);
//            break;
//    }
    VertexOut vOut;
    vOut.position = float4(pos, 0,1);
    vOut.color = vert.color;
    return vOut;
}

fragment float4 rect_frag(VertexOut vIn [[ stage_in ]]) {
    return vIn.color;
}

