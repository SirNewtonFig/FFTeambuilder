import { Controller } from "@hotwired/stimulus"

export default class TabController extends Controller {
  static targets = ['tab', 'pane']

  static values = {
    activeClasses: Array,
    inactiveClasses: Array,
    paneToggleClass: String
  }

  connect() {
    this.click({ target: this.tabTargets[0] })
  }

  click(event) {
    let tabIndex = this.tabTargets.indexOf(event.target)

    this.tabTargets.forEach((tab, index) => {
      if (index == tabIndex) {
        tab.classList.remove(...this.inactiveClassesValue)
        tab.classList.add(...this.activeClassesValue)
        this.paneTargets[index].classList.remove(this.paneToggleClassValue)
      } else {
        tab.classList.add(...this.inactiveClassesValue)
        tab.classList.remove(...this.activeClassesValue)
        this.paneTargets[index].classList.add(this.paneToggleClassValue)
      }
    })
  }
}
