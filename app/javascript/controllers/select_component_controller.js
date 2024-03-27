import { Controller } from "@hotwired/stimulus"
import Combobox from "@github/combobox-nav"
import debounce from "lodash.debounce"

// Connects to data-controller="select-component"
export default class extends Controller {
  static values = {
    src: String,
    multiple: {
      type: Boolean,
      default: false,
    },
    updateFromSrcDebounceMs: {
      type: Number,
      default: 300,
    },
    newItemParamName: String
  }

  static targets = [
    "input",
    "menu",
    "list",
    "selected",
    "frame",
    "emptyResults",
    "listOption",
    "newItemLink"
  ]

  // START LIFECYCLE FUNCTIONS
  initialize() {
    this.updateListFromSrc = debounce(
      this.updateListFromSrc.bind(this),
      this.updateFromSrcDebounceMsValue
    );
  }

  connected() {
    this.interacting = false;
    this.hideMenu();
  }

  /**
   * @param {Element} target
   */
  selectedTargetConnected(target) {
    this.observer = new MutationObserver((_records, _observer) => {
      target.dispatchEvent(
        new Event("change", {
          bubbles: true,
          cancelable: false,
        }),
      );
    });
    this.observer.observe(target, {
      childList: true,
    });
  }

  selectedTargetDisconnected() {
    this.observer.disconnect();
  }

  listTargetConnected() {
    this.clearAndStartCombobox();
  }

  disconnect() {
    this.combobox?.destroy();
  }
  // END LIFECYCLE FUNCTIONS

  clearAndStartCombobox() {
    this.combobox?.destroy();
    this.combobox = new Combobox(this.inputTarget, this.listTarget);
    this.combobox.start();
  }

  updateList(event) {
    if (this.hasSrcValue && this.hasFrameTarget) {
      this.updateListFromSrc(event);
    } else {
      this.updateListLocally(event);
    }
  }

  setNewItemUrlParam(event) {
    if (this.hasNewItemLinkTarget) {
      const { value } = event.target;
      this.newItemLinkTarget.href = this.updateQueryParam(
        this.newItemLinkTarget.href,
        this.newItemParamNameValue,
        value
      )
    }
  }

  updateQueryParam(url, key, value) {
    const urlObj = new URL(url);
    urlObj.searchParams.set(key, value);
    return urlObj.toString();
  }

  updateListFromSrc({ target }) {
    const { name, value } = target;

    if (this.hasFrameTarget) {
      const url = new URL(this.srcValue, document.location);
      url.searchParams.append(name, value);

      this.frameTarget.src = url;
    } else {
      console.error("Need frame target");
    }
  }

  updateListLocally({ target }) {
    const { value } = target;

    this.hideEmptyResultsOption();
    const foundMatch = this.filterOptionsByValue(value);

    if (!foundMatch) {
      this.showEmptyResultsOption();
    }
  }

  filterOptionsByValue(value) {
    let foundMatch = false;

    for (let option of this.listOptionTargets) {
      if (value === "" || this.includesValue(
        option.textContent,
        value
      )) {
        this.showOption(option);
        foundMatch = true;
      } else {
        this.hideOption(option);
      }
    }

    return foundMatch;
  }

  keydown({ key }) {
    switch (key) {
      case "Escape":
        this.hideMenu();
        break;
      case "Backspace":
        if (this.inputTarget.value == "") {
          this.clearLastSelection();
        }
    }
  }

  interactingWithMenu() {
    this.interacting = true;
  }

  updateSelected({ target }) {
    if (target instanceof Element) {
      this.updateSelections(target);
      this.clearInput();
      this.focusInput();
      this.hideMenu();
    }
  }

  clearInput() {
    this.inputTarget.value = "";
    this.inputTarget.dispatchEvent(
      new InputEvent("input", {
        bubbles: true,
        cancelable: false,
      }),
    );
  }

  focusInput() {
    this.inputTarget.focus();
  }

  /**
   * @param {Element} targetWithTemplate 
   */
  updateSelections(targetWithTemplate) {
    const template = targetWithTemplate.querySelector("template");
    if (!template) return;

    const selection = template.content.cloneNode(true);

    if (this.multipleValue) {
      const hiddenInput = selection.querySelector("input");
      hiddenInput.setAttribute("multiple", "multiple");

      const matchingSelectedInput = this.selectedTarget.querySelector(
        `input[value='${hiddenInput.getAttribute("value")}']`
      );
      if (matchingSelectedInput) {
        matchingSelectedInput.parentElement.remove();
      }

      this.selectedTarget.append(selection);
    } else {
      this.selectedTarget.innerHTML = "";
      this.selectedTarget.append(selection);
    }
  }

  clearLastSelection() {
    const removables = this.selectedTarget.querySelectorAll(
      "[data-remove-target]"
    );
    const nextRemoveable = Array.from(removables).at(-1);
    nextRemoveable?.remove();
  }

  showMenu() {
    this.menuTarget.hidden = false;
  }

  hideMenu() {
    if (this.interacting) {
      this.interacting = false;
      return;
    }
    if (!this.menuTarget.hidden) {
      this.menuTarget.hidden = true;
    }
  }

  hideEmptyResultsOption() {
    if (this.hasEmptyResultsTarget) {
      this.emptyResultsTarget.hidden = true;
    }
  }

  showEmptyResultsOption() {
    if (this.hasEmptyResultsTarget) {
      this.emptyResultsTarget.hidden = false;
    }
  }

  includesValue(text, search) {
    return text.toLowerCase().includes(search.toLowerCase());
  }

  showOption(option) {
    option.hidden = false;
    option.classList.remove("hidden");
  }

  hideOption(option) {
    option.hidden = true;
    option.classList.add("hidden");
  }
}
