import { Controller } from "@hotwired/stimulus"

export default class DraggablePositionController extends Controller {
  connect() {
    this.enforceBoundary()
  }
  
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
      er = rect.right + deltaX,
      eb = rect.bottom + deltaY,
      el = rect.left + deltaX,
      et = rect.top + deltaY

    // if (er > vw) {
    //   deltaX = vw - rect.right
    // }

    // if (el < 0) {
    //   deltaX = 0
    // }

    // if (et < 0) {
    //   deltaY = 0
    // }

    // if (eb > vh) {
    //   deltaY = vh - rect.bottom
    // }

    this.left = rect.x + deltaX
    this.top = rect.y + deltaY

    this.enforceBoundary()
  }

  enforceBoundary() {
    let boundary = document.querySelector('#draggable-container').getBoundingClientRect(),
      rect = this.element.getBoundingClientRect()

    if (rect.right > boundary.right) {
      this.left = boundary.right - (rect.right - rect.left)
    } else if (rect.left < boundary.left) {
      this.left = boundary.left
    }

    if (rect.bottom > boundary.bottom) {
      this.top = boundary.bottom - (rect.bottom - rect.top)
    } else if (rect.top < boundary.top) {
      this.top = boundary.top
    }
  }

  set left(left) {
    this.element.style.left = left + 'px'
  }
  
  set top(top) {
    this.element.style.top = top + 'px'
  }
}