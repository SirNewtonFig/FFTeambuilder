import { Controller } from "@hotwired/stimulus"

export default class AutoScrollController extends Controller {
  connect() {
    this.element.scrollIntoView({behavior: "smooth", block: "center"});
  }
}
