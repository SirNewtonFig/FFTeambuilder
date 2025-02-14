import { Controller } from "@hotwired/stimulus"

export default class MemgenMenuController extends Controller {
  static targets = ['list', 'template', 'slot']
  
  connect() {
    document.querySelector('#bracket').classList.add('memgen')
    document.querySelector('#tabs').classList.add('memgen')
    document.querySelector('#memgen-link').classList.add('hidden')

    this.addBlock()
  }

  disconnect() {
    document.querySelector('#bracket').classList.remove('memgen')
    document.querySelector('#tabs').classList.remove('memgen')
    document.querySelector('#memgen-link').classList.remove('hidden')
  }

  close() {
    this.element.remove()
  }

  addBlock() {
    this.listTarget.append(this.templateTarget.content.cloneNode(true))
  }

  addPlayer(element) {
    let id = parseInt(element.dataset.playerId),
      name = element.querySelector('title').textContent,
      slot = this.emptySlot

    slot.querySelector('input').value = id
    slot.querySelector('span').innerHTML = name
    slot.classList.remove('text-gray-600', 'italic')
    slot.classList.add('text-gray-100')
  }

  get emptySlot() {
    let slot = this.slotTargets.find((slot) => !slot.querySelector('input').value)

    if (!slot) {
      this.addBlock()

      return this.slotTargets.find((slot) => !slot.querySelector('input').value)
    }

    return slot
  }
}
