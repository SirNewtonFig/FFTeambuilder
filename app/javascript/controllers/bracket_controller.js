import { Controller } from "@hotwired/stimulus"
import { Draggable } from '@shopify/draggable'

export default class BracketController extends Controller {
  static outlets = ['memgen-menu']
  
  pick(event) {
    if (this.hasMemgenMenuOutlet) {
      event.preventDefault()
      
      this.memgenMenuOutlet.addPlayer(event.currentTarget)
    }
  }
}
