import { Controller } from "@hotwired/stimulus"

export default class TabController extends Controller {
  static targets = ['counter', 'item']

  initialize() {
    this.counters = {}
  }

  updateCounter(scope) {
    let counter = this.counterTargets.find((counter) => counter.dataset.scope === scope)

    if (this.counters[scope]) {
      counter.innerHTML = this.counters[scope]
    } else {
      counter.innerHTML = '0'
    }
  }
  
  itemTargetConnected(item) {
    let scope = item.dataset.scope,
      count = this.counters[scope]

    if (!scope) {
      return
    }

    if (!count) {
      this.counters[scope] = 1
    } else {
      this.counters[scope] = count + 1
    }

    this.updateCounter(scope)
  }

  itemTargetDisconnected(item) {
    let scope = item.dataset.scope,
      count = this.counters[scope]

    if (!scope || !count) {
      return
    } else {
      this.counters[scope] = count - 1
    }

    this.updateCounter(scope)
  }
}
