import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove"
export default class extends Controller {
  static targets = ["removee"]

  call() {
    this.triggerInputEvents();
    this.removeeTarget?.remove();
  }

  triggerInputEvents() {
    var event = new Event('input', { bubbles: true });
    this.removeeTarget.dispatchEvent(event);
  }
}
