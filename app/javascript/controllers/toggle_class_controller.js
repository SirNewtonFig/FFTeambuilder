import { Controller } from "@hotwired/stimulus"

export default class ToggleClassController extends Controller {
  static values = { class: String, target: String }
  
  toggle() {
    this.toggleTarget.classList.toggle(this.classValue)
  }

  off() {
    this.toggleTarget.classList.remove(this.classValue)
    this.element.checked = false
  }

  get toggleTarget() {
    return document.querySelector(this.targetValue)
  }
}
