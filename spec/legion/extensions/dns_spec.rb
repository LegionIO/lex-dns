# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::Dns do
  it 'has a version number' do
    expect(Legion::Extensions::Dns::VERSION).not_to be_nil
  end

  it 'has a non-empty version string' do
    expect(Legion::Extensions::Dns::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
