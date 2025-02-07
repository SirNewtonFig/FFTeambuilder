import { Controller } from "@hotwired/stimulus"
import { createPopper } from '@popperjs/core/dist/esm'
import { useClickOutside } from 'stimulus-use'

export default class ContextController extends Controller {
  static targets = ['tooltip']

  static values = {
    placement: { type: String, default: 'top-end' }
  }

  connect() {
    useClickOutside(this)
  }

  help(event) {
    if (this.element.closest('.tooltip-highlight')) {
      const helpEvent = new CustomEvent("context:help", { bubbles: true })
      this.element.dispatchEvent(helpEvent)
      
      event.preventDefault()
      event.stopPropagation()
      this.open()
    }
  }

  open() {
    if (this.hasTooltipTarget) {
      this.popper = createPopper(this.element, this.tooltipTarget, {
        placement: this.placementValue,
        modifiers: [
          {
            name: 'offset', options: { offset: [0, 4] }
          }
        ]
      })

      this.tooltipTarget.classList.remove('hidden')

      document.body.classList.add('overflow-hidden')
      this.overlay?.classList.remove('hidden')
    }
  }

  close() {
    this.popper?.destroy()

    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.add('hidden')
    }

    document.body.classList.remove('overflow-hidden')
    this.overlay?.classList.add('hidden')
  }

  clickOutside() {
    this.close()
  }

  get overlay() {
    return document.querySelector('#overlay')
  }
}
