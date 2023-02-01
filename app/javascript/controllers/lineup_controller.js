import { Controller } from "@hotwired/stimulus"
import { Sortable } from '@shopify/draggable'

export default class LineupController extends Controller {
  static targets = ['form', 'container', 'character']

  connect() {
    this.sortable = new Sortable(this.containerTarget, { draggable: '.draggable', distance: 15 })

    this.sortable.on('drag:stopped', () => {
      fetch(this.formTarget.action, {
        method: 'PATCH',
        body: new FormData(this.formTarget)
      }).then(() => this.refresh())
    })
  }

  disconnect() {
    delete this.sortable
  }

  select(event) {
    const path = `/characters/${event.currentTarget.dataset.index}/edit`

    document.querySelector('#character_editor').src = path
  }

  refresh() {
    this.characterTargets.forEach((char) => {
      const i = this.characterTargets.indexOf(char)

      char.dataset.index = i

      char.querySelector('.container').id = `character-${i}`

      char.querySelector('input[name="chars[]"').value = i
    })
  }

  // get formData() {
  //   const data = new FormData(this.formTarget),
  //     plain = Object.fromEntries(data.entries())

  //   delete plain['chars[]']

  //   plain.chars = []

  //   return JSON.stringify(plain)
  // }
}
