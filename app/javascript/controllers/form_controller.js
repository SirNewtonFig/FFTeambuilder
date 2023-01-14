import { Controller } from "@hotwired/stimulus"

export default class FormController extends Controller {
  submit() {
    this.element.requestSubmit()
  }
}
