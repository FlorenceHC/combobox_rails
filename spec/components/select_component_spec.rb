# frozen_string_literal: true

require "rails_helper"

RSpec.describe SelectComponent, type: :component do
  it "passes through classes when provided" do
    render_inline(
      described_class.new(
        form: instance_double(
          ActionView::Helpers::FormBuilder,
          field_name: "task_id",
          hidden_field: "task_id"
        ),
        name: "task_id",
        classes: "a list of classes"
      )
    )

    expect(page).to have_css("div", class: "a list of classes")
  end

  it "renders the text input with the correct field name" do
    placeholder = "placeholder"
    render_inline(
      described_class.new(
        form: instance_double(
          ActionView::Helpers::FormBuilder,
          field_name: "task_id",
          hidden_field: "task_id"
        ),
        name: "task_id",
        placeholder: placeholder,
        required: false,
        fetch_url: "/tasks",
        fetch_field_name: "search_tasks"
      )
    )

    expect(page).to have_field(
      "search_tasks",
      placeholder: placeholder
    )
  end

  it "renders an screen reader label when label_visible is false" do
    render_inline(
      described_class.new(
        form: instance_double(
          ActionView::Helpers::FormBuilder,
          field_name: "task_id",
          hidden_field: "task_id"
        ),
        name: "task_id",
        label: "Label",
        label_visible: false
      )
    )

    expect(page).to have_css(
      "label",
      text: "Label",
      class: "sr-only"
    )
  end

  describe "with fetch_url" do
    it "adds a hidden turbo frame with the correct src" do
      render_inline(
        described_class.new(
          form: instance_double(
            ActionView::Helpers::FormBuilder,
            field_name: "task_id",
            hidden_field: "task_id"
          ),
          name: "task_id",
          required: false,
          fetch_url: "/tasks",
          fetch_field_name: "task_search"
        )
      )

      expect(page).to have_css(
        turbo_frame_selector(src: "/tasks?field_name=task_id"),
        visible: :hidden
      )
    end
  end

  describe "with_select_list" do
    context "when fetch_url is specified" do
      it "renders the list and items inside a hidden turbo frame" do
        render_inline(
          described_class.new(
            form: instance_double(
              ActionView::Helpers::FormBuilder,
              field_name: "task_id",
              hidden_field: "task_id"
            ),
            name: "task_id",
            required: false,
            fetch_url: "/tasks"
          )
        ) do |select|
          select.with_select_list do |select_list|
            TasksController::TASKS.each do |task|
              select_list.with_select_list_item(item: task) do |select_list_item|
                task.name
              end
            end
          end
        end

        expect(page).to have_css(
          "#{turbo_frame_selector} #{select_list_selector}",
          visible: :hidden
        )
        expect(page).to have_css(
          "#{turbo_frame_selector} #{select_list_selector} li[role='option']",
          visible: :hidden,
          count: TasksController::TASKS.length
        )
      end
    end

    context "when there is no fetch_url specified" do
      it "renders the hidden list without a turbo frame" do
        render_inline(
          described_class.new(
            form: instance_double(
              ActionView::Helpers::FormBuilder,
              field_name: "task_id",
              hidden_field: "task_id"
            ),
            name: "task_id",
            required: false
          )
        ) do |select|
          select.with_select_list do |select_list|
            TasksController::TASKS.each do |task|
              select_list.with_select_list_item(item: task) do |select_list_item|
                task.name
              end
            end
          end
        end

        expect(page).not_to have_css(turbo_frame_selector)

        expect(page).to have_css(
          select_list_selector.to_s,
          visible: :hidden
        )
        expect(page).to have_css(
          "#{select_list_selector} #{select_list_item_selector}",
          visible: :hidden,
          count: TasksController::TASKS.length
        )
      end
    end
  end

  describe "with_noscript_fallback" do
    it "renders a HTML select" do
      form_double = instance_double(
        ActionView::Helpers::FormBuilder,
        field_name: "task_id",
        hidden_field: "task_id",
        select: select_tag("task_id", task_options_for_select)
      )

      render_inline(
        described_class.new(
          form: form_double,
          name: "task_id",
          label: "Search"
        )
      ) do |select|
        select.with_noscript_fallback(
          collection: task_options_for_select
        )
      end

      expect(form_double).to have_received(:select).with(
        "task_id",
        task_options_for_select,
        {include_blank: false},
        {
          required: false,
          multiple: false,
          class: anything,
          aria: {
            label: "Search"
          }
        }
      )
      expect(page).to have_css("noscript select[name='task_id']")
    end

    it "renders a HTML multiple select when multiple is true" do
      form_double = instance_double(
        ActionView::Helpers::FormBuilder,
        field_name: "task_ids[]",
        hidden_field: "task_ids[]",
        select: select_tag("task_ids[]", task_options_for_select, multiple: true)
      )

      render_inline(
        described_class.new(
          form: form_double,
          name: "task_ids",
          required: false,
          multiple: true,
          label: "Search"
        )
      ) do |select|
        select.with_noscript_fallback(
          collection: task_options_for_select
        )
      end

      expect(form_double).to have_received(:select).with(
        "task_ids",
        task_options_for_select,
        {include_blank: false},
        {
          required: false,
          multiple: true,
          class: anything,
          aria: {
            label: "Search"
          }
        }
      )
      expect(page).to have_css("noscript select[name='task_ids[]'][multiple='multiple']")
    end
  end

  describe "with_selected_items" do
    it "renders a hidden input field for each selected item's id" do
      stubbed_user = User.find(1)
      form_double = instance_double(
        ActionView::Helpers::FormBuilder,
        field_name: "user_ids[]"
      )
      allow(form_double).to receive(:hidden_field).and_return(
        "user_ids_hidden_input_field"
      )

      render_inline(
        described_class.new(
          form: form_double,
          name: "user_ids",
          multiple: true
        )
      ) do |select|
        select.with_selected_item(item: stubbed_user)
      end

      expect(form_double).to have_received(:hidden_field).with(
        "user_ids",
        value: 1,
        id: "user_1",
        multiple: true
      )
      expect(page).to have_content("user_ids_hidden_input_field")
    end
  end

  private

  def turbo_frame_selector(src: nil)
    if src.present?
      "turbo-frame[src='#{src}']"
    else
      "turbo-frame:not([src])"
    end
  end

  def select_list_selector
    "ul[role='listbox']"
  end

  def select_list_item_selector
    "li[role='option']"
  end

  def task_options_for_select
    TasksController::TASKS.map { |task| [task.name, task.id] }
  end
end
