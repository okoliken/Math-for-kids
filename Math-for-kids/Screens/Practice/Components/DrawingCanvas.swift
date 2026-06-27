//
//  DrawingCanvas.swift
//  Math-for-kids
//
//  Created by Jeffery Okoli on 15/06/2026.
//

import PencilKit
import SwiftUI

/// Drives undo / redo / clear on a `DrawingCanvas` and tracks whether each is
/// currently available, so the board's buttons can enable and disable.
@Observable
final class DrawingCanvasController {
    @ObservationIgnored fileprivate weak var canvas: PKCanvasView?

    var canUndo = false
    var canRedo = false

    func undo() {
        canvas?.undoManager?.undo()
        refresh()
    }

    func redo() {
        canvas?.undoManager?.redo()
        refresh()
    }

    func clear() {
        guard let canvas, !canvas.drawing.strokes.isEmpty else { return }
        // Register the wipe so it can be undone like any other edit.
        let previous = canvas.drawing
        canvas.undoManager?.registerUndo(withTarget: canvas) { $0.drawing = previous }
        canvas.drawing = PKDrawing()
        refresh()
    }

    fileprivate func refresh() {
        canUndo = canvas?.undoManager?.canUndo ?? false
        canRedo = canvas?.undoManager?.canRedo ?? false
    }
}

/// A SwiftUI wrapper over `PKCanvasView` for free-hand drawing. Accepts finger
/// input (so it works without an Apple Pencil) and writes in chalky white.
struct DrawingCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    var controller: DrawingCanvasController?
    var inkColor: UIColor = .white
    var inkWidth: CGFloat = 6

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = UndoableCanvasView()
        canvas.drawingPolicy = .anyInput // finger or Apple Pencil
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.tool = PKInkingTool(.pen, color: inkColor, width: inkWidth)
        canvas.drawing = drawing
        canvas.delegate = context.coordinator
        controller?.canvas = canvas
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        // Reflect external resets without clobbering strokes already on canvas.
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }
        canvas.tool = PKInkingTool(.pen, color: inkColor, width: inkWidth)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        private let parent: DrawingCanvas

        init(_ parent: DrawingCanvas) { self.parent = parent }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
            parent.controller?.refresh()
        }
    }
}

/// A canvas that owns its undo manager, so drawing edits are independently
/// undoable regardless of the surrounding responder chain.
private final class UndoableCanvasView: PKCanvasView {
    private let ownUndoManager = UndoManager()
    override var undoManager: UndoManager? { ownUndoManager }
}
