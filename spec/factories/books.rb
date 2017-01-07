# frozen_string_literal: true
FactoryGirl.define do
  factory :book, class: Book do
    id { 1 }
    title { "神探伽利略" }
    author { "東野圭吾" }
    genre { "推理" }
  end
end
