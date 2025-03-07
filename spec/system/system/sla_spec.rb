# Copyright (C) 2012-2021 Zammad Foundation, http://zammad-foundation.org/

require 'rails_helper'

RSpec.describe 'System > Sla', type: :system do
  before do
    ensure_websocket do
      visit 'manage/slas'
    end
  end

  it 'shows correct required behaviour for checkboxes' do
    page.find('.js-new').click

    # enable all checkboxes
    page.find('input#update_time', visible: false).find(:xpath, './/..').click
    page.find('input#solution_time', visible: false).find(:xpath, './/..').click

    # check if required
    expect(page.find('input[name=first_response_time_in_text]')[:required]).to eq('true')
    expect(page.find('input[name=update_time_in_text]')[:required]).to eq('true')
    expect(page.find('input[name=solution_time_in_text]')[:required]).to eq('true')

    # drop all checkboxes
    page.find('input#first_response_time', visible: false).find(:xpath, './/..').click
    page.find('input#update_time', visible: false).find(:xpath, './/..').click
    page.find('input#solution_time', visible: false).find(:xpath, './/..').click

    # check if optional
    expect(page.find('input[name=first_response_time_in_text]')[:required]).not_to eq('true')
    expect(page.find('input[name=update_time_in_text]')[:required]).not_to eq('true')
    expect(page.find('input[name=solution_time_in_text]')[:required]).not_to eq('true')
  end

  describe 'for saved entry', authenticated_as: :authenticate do
    def authenticate
      create(:sla, name: 'special sla', first_response_time: 3600, update_time: 3600, solution_time: 3600)
      true
    end

    it 'shows correct required behaviour for checkboxes' do
      page.find('.js-edit').click

      # check if required
      expect(page.find('input[name=first_response_time_in_text]')[:required]).to eq('true')
      expect(page.find('input[name=update_time_in_text]')[:required]).to eq('true')
      expect(page.find('input[name=solution_time_in_text]')[:required]).to eq('true')

      # drop all checkboxes
      page.find('input#first_response_time', visible: false).find(:xpath, './/..').click
      page.find('input#update_time', visible: false).find(:xpath, './/..').click
      page.find('input#solution_time', visible: false).find(:xpath, './/..').click

      # check if optional
      expect(page.find('input[name=first_response_time_in_text]')[:required]).not_to eq('true')
      expect(page.find('input[name=update_time_in_text]')[:required]).not_to eq('true')
      expect(page.find('input[name=solution_time_in_text]')[:required]).not_to eq('true')
    end
  end
end
