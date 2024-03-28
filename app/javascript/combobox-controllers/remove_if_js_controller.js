import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-if-js"
export default class extends Controller {
  connect() {
    this.element.remove();
  }
}
