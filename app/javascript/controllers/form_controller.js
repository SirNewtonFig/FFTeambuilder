import { Controller } from "@hotwired/stimulus"

export default class FormController extends Controller {
  static outlets = ['modal']

  submit() {
    this.element.requestSubmit()

    if (this.hasModalOutlet) {
      this.modalOutlet.close()
    }
  }
}
