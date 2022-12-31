import { Controller } from "@hotwired/stimulus"

export default class FormController extends Controller {
  submit() {
    this.element.dispatchEvent(new CustomEvent('submit', { bubbles: true }))
  }
}
