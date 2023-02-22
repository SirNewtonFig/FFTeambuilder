import { Controller } from "@hotwired/stimulus"
import { UAParser } from 'ua-parser-js'
import _ from 'lodash'

export default class QuickFilterController extends Controller {
  static outlets = ['filterable']

  connect() {
    const ua = new UAParser(),
      deviceType = ua.getDevice().type

    if (deviceType !== 'mobile' && deviceType !== 'tablet') {
      this.element.focus()
    }
  }

  filter() {
    const partitions = _.partition(this.filterableOutletElements, (item) => {
      if (this.element.value === '') {
        return true
      }

      return _.every(this.queryParts, (part) => item.textContent.match(new RegExp(part, 'i')))
    })

    partitions[0].forEach((item) => item.classList.remove('hidden'))
    partitions[1].forEach((item) => item.classList.add('hidden'))
  }

  get queryParts() {
    return this.element.value.split(' ')
  }
}
