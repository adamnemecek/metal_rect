//
//  Renderer.swift
//  macOSMetal
//
//  Created by Zach Eriksen on 4/30/18.
//  Copyright © 2018 Zach Eriksen. All rights reserved.
//

import MetalKit

//struct Vertex {
//    var position: float3
//    var color: float4
//}

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertexBuffer: MTLBuffer!
    var uniformsBuffer: MTLBuffer!
//    var vertices: [Vertex] = [
//        Vertex(position: float3(0,1,0), color: float4(1,0,0,1)),
//        Vertex(position: float3(-1,-1,0), color: float4(0,1,0,1)),
//        Vertex(position: float3(1,-1,0), color: float4(0,0,1,1))
//    ]

    let content: [Rect1] = [
        Rect1(x: -0.5, y: -0.5, w: 0.6, h: 0.3, color: float4(1,0,0,1)),
        Rect1(x: 0.3, y: -0.5, w: 0.3, h: 0.3, color: float4(1,0,0,1)),
        Rect1(x: 0.5, y: 0.5, w: 0.3, h: 0.3, color: float4(1,0,0,1)),
        Rect1(x: 0.5, y: -0.4, w: 0.3, h: 0.3, color: float4(1,0,0,1))
    ]

    private var uniforms = Uniforms()
    
    init(device: MTLDevice) {
        super.init()
        createCommandQueue(device: device)
        createPipelineState(device: device)
        createBuffers(device: device)
    }
    
    //MARK: Builders
    func createCommandQueue(device: MTLDevice) {
        commandQueue = device.makeCommandQueue()
    }
    
    func createPipelineState(device: MTLDevice) {
        // The device will make a library for us
        let library = device.makeDefaultLibrary()
        // Our vertex function name
        let vertexFunction = library?.makeFunction(name: "rect_vert")
        // Our fragment function name
        let fragmentFunction = library?.makeFunction(name: "rect_frag")
        // Create basic descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        // Attach the pixel format that si the same as the MetalView
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        // Attach the shader functions
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        // Try to update the state of the renderPipeline

        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: content,
                                         length: MemoryLayout<Rect1>.stride * content.count,
                                         options: [])
        uniformsBuffer = device.makeBuffer(bytes: &uniforms,
                                         length: MemoryLayout<Uniforms>.stride,
                                         options: [])
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        // Get the current drawable and descriptor
        guard let drawable = view.currentDrawable,
            let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
        }

//        print("width \(drawable.texture.width), height: \(drawable.texture.height)")
        self.uniforms.height = Float(drawable.texture.height)
        self.uniforms.width = Float(drawable.texture.width)

        // Create a buffer from the commandQueue
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            fatalError()
        }
        commandEncoder.setRenderPipelineState(renderPipelineState)

        // Pass in the vertexBuffer into index 0
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        uniformsBuffer.contents().copyMemory(from: &uniforms, byteCount: MemoryLayout<Uniforms>.size)
        commandEncoder.setVertexBuffer(uniformsBuffer, offset: 0, index: 1)
        // Draw primitive at vertextStart 0
//        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

//        commandEncoder?.drawPrimitives(type: .triangle,
//                                       vertexStart: 0,
//                                       vertexCount: vertices.count)

        commandEncoder.drawPrimitives(type: .triangleStrip,
                                    vertexStart: 0,
                                    vertexCount: 4,
                                    instanceCount: content.count)
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
