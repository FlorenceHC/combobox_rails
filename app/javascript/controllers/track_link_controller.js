import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = {
    eventName: String,
    properties: Object,
  };

  connect() {
    analytics.trackLink(
      this.element,
      this.eventNameValue,
      this.propertiesValue
    );
  }
}
