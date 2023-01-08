import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class ModalController extends Controller {
  connect() {
    useClickOutside(this)

    document.body.classList.add('overflow-hidden')
  }

  disconnect() {
    document.body.classList.remove('overflow-hidden')
  }

  close() {
    this.element.closest('.modal-content').remove()
  }

  clickOutside() {
    this.close()
  }

  keydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
