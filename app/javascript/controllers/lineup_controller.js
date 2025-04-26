import { Controller } from "@hotwired/stimulus"
import { Sortable } from '@shopify/draggable'

export default class LineupController extends Controller {
  static targets = ['form', 'character', 'index']

  connect() {
    this.sortable = new Sortable(this.element, { draggable: '.draggable', distance: 15 })

    this.sortable.on('drag:stopped', () => {
      this.formTarget.requestSubmit()

      this.refresh()
    })
  }

  disconnect() {
    delete this.sortable
  }

  select(event) {
    let index = event.currentTarget.dataset.index,
      path

    this.indexTarget.value = index

    if (this.element.dataset.readonly) {
      path = `/submissions/${event.currentTarget.dataset.team}/characters/${index}`
    } else {
      path = `/teams/${event.currentTarget.dataset.team}/characters/${index}/edit`
    }

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
}
