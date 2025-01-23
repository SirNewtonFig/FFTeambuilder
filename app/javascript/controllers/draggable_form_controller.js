import { Controller } from "@hotwired/stimulus"
import { Sortable } from '@shopify/draggable'

export default class DraggableFormController extends Controller {
  static targets = ['form', 'list']

  connect() {
    this.sortable = new Sortable(this.listTarget, { draggable: '.draggable', distance: 10 })

    this.sortable.on('drag:stopped', () => {
      this.formTarget.requestSubmit()
    })
  }

  disconnect() {
    delete this.sortable
  }
}
