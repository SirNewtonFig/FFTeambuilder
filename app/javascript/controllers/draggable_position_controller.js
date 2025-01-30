import { Controller } from "@hotwired/stimulus"

export default class DraggablePositionController extends Controller {
  dragStart() {
    this.dragging = true
  }

  dragEnd() {
    this.dragging = false
  }

  move(event) {
    if (!this.dragging) {
      return
    }

    let deltaX = event.movementX,
      deltaY = event.movementY,
      rect = this.element.getBoundingClientRect(),
      vw = document.documentElement.clientWidth || 0,
      vh = document.documentElement.clientHeight || 0,
      er = rect.right + deltaX,
      eb = rect.bottom + deltaY,
      el = rect.left + deltaX,
      et = rect.top + deltaY

    if (er > vw) {
      deltaX = vw - rect.right
    }

    if (el < 0) {
      deltaX = 0
    }

    if (et < 0) {
      deltaY = 0
    }

    if (eb > vh) {
      deltaY = vh - rect.bottom
    }

    this.element.style.left = rect.x + deltaX + 'px'
    this.element.style.top = rect.y + deltaY + 'px'
  }
}
