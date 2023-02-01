import { Controller } from "@hotwired/stimulus"
import _ from 'lodash'

export default class QuickFilterController extends Controller {
  static outlets = ['filterable']

  filter() {
    const partitions = _.partition(this.filterableOutletElements, (item) => {
      if (this.element.value === '') {
        return true
      }

      return _.every(this.queryParts, (part) => item.textContent.match(new RegExp(part, 'i')))
    })

    // debugger

    partitions[0].forEach((item) => item.classList.remove('hidden'))
    partitions[1].forEach((item) => item.classList.add('hidden'))
  }

  get queryParts() {
    return this.element.value.split(' ')
  }
}
