# jurou / 翻譯蒟蒻
[![Gem Version](https://badge.fury.io/rb/jurou.svg)](https://badge.fury.io/rb/jurou)
[![Code Climate](https://codeclimate.com/github/jodeci/jurou/badges/gpa.svg)](https://codeclimate.com/github/jodeci/jurou)
[![Test Coverage](https://codeclimate.com/github/jodeci/jurou/badges/coverage.svg)](https://codeclimate.com/github/jodeci/jurou/coverage)
[![Build Status](https://travis-ci.org/jodeci/jurou.svg?branch=master)](https://travis-ci.org/jodeci/jurou)

A collection of i18n related view helpers for Rails. Work in progress.

Lets say we have a model `Book`. `Book.genre` is a pre defined list of book genres, such as `fantasy, detective, romance, history, manga`. 

Most developers stick to English (at least the Latin alphabet) for such values. The thing is, your app more than often requires you to display them as `奇幻, 推理, 羅曼史, 歷史, 漫畫` or whatever your native language. 

Although there's the handy I18n API for localization, turns out this was still a messier process than I imagined. To keep things DRY I put together *jurou* for myself.

## Installation

Tested on Ruby 2.3.1 and Rails 5.

```
# Gemfile
gem "jurou"
```

```
$ bundle install
```

Generate the locale yml file. Defaults to your application's `default_locale` if `--locale` not specified.

```
$ rails generate jurou:install
$ rails generate jurou:install --locale ja
```

## Examples

Fill in the details in the generated locale file:

```
# config/locale/jurou.zh-TW.yml
zh-TW:
  jurou:
    book:
      genre:
        fantasy: 奇幻
        detective: 推理
        romance: 羅曼史
        history: 歷史
        manga: 漫畫
        
    app_title: 翻譯蒟蒻
    
    page_titles:
      books:
        _label: 我的書櫃
        index: 書籍列表
        edit: 修改書籍
      admin/sales:
        index: 銷售紀錄
        
  activerecord:
    attributes:
      book:
        title: 書名
        author: 作者
        genre: 類別
```
### jr\_collection

Use `jr_collection` in your form template:

```
# app/views/books/_form.html.slim
= simple_form_for @book do |f|
  = f.input :genre, collection: jr_collection(:genre, :book)
```

*jurou* will then generate the collection hash for the form helper, resulting in the following HTML:

```
<select>
  <option value="fantasy">奇幻</option>
  <option value="detective">推理</option> 
  <option value="romance">羅曼史</option>
  <option value="history">歷史</option> 
  <option value="manga">漫畫</option> 
</select>
```

### jr\_attribute
 
`jr_attribute` simply outputs the corresponding translation of the attribute. Shorthand `jr_attr` also available.

```
jr_attribute :author, :book
=> "作者"
```

### jr\_value

`jr_value` is only useful when you need to get the translation for the attribute value itself. 

```
jr_value :genre, @book.genre, :book
=> "推理"
```

### jr\_table\_row, jr\_table\_row\_translate\_value

Or, if you're lazy enough like me, there's also `jr_table_row` and `jr_table_row_translate_value` which takes advantage of `jr_attribute` and `jr_value` to make a quick and dirty table display. Shorthand `jr_row` and `jr_row_val` also available. 

```
# app/views/books/show.html.slim
table
  = jr_table_row :title, @book.title, :book
  = jr_table_row :author, @book.author, :book
  = jr_table_row_translate_value :genre, @book.genre, :book
```

This will produce the following HTML:

```
<table>
  <tr>
    <th>書名</th>
    <td>神探伽利略</td>
  </tr>
  <tr>
    <th>作者</th>
    <td>東野圭吾</td>
  </tr>
  <tr>
    <th>類別</th>
    <td>推理</td>
  </tr>
</table>
```

#### Be more lazy!

For the above helpers, you can omit passing `:book` all together if you are following Rails naming convention:

```
jr_row :title, @book.title
=> <tr><th>作者</th><td>神探伽利略</td></tr>

jr_row_val :genre, @book.genre
=> <tr><th>類別</th><td>推理</td></tr>

jr_attr :author
=> 作者

jr_value :genre, @book.genre
=> 推理

jr_collection :genre
=> { fantasy: "奇幻", detective: "推理", romance: "羅曼史", history: "歷史", manga: "漫畫" }
```

#### More laziness with shikigami

If you are using *[shikigami](https://github.com/jodeci/shikigami)*, *jurou* will fallback to the `current_object` whenever possible, so you can just write this and be done:

```
jr_row :title
=> <tr><th>作者</th><td>神探伽利略</td></tr>

jr_row_val :genre
=> <tr><th>類別</th><td>推理</td></tr>
```

### jr\_page\_title 

`jr_page_title` generates the page title based on the current controller and action. It will fallback to your app title when there is no match.
 
```
# app/views/layout/application.html.slim
= title content_for?(:jr_title) ? yield(:jr_title) : jr_page_title

# BooksController#index
=> "書籍列表 | 翻譯蒟蒻"

# MoviesController#index
=> "翻譯蒟蒻"
```
### jr\_content\_for_page\_title

You can further customize the title with `jr_content_for_page_title`, or `jr_title`
 for short.

```
# app/views/books/edit.html.slim
= jr_content_for_page_title("神探伽利略")

# BooksController#edit
=> "神探伽利略 | 修改書籍 | 翻譯蒟蒻"
```

### jr\_simple\_title
Use `jr_simple_title` when you need to manually get a page title, instead of relying on the black magic of `jr_page_title`. The app title will not be included. Comes in handy when building dropdown menus.

```
# defaults to the current controller/action
jr_simple_title
=> "書籍列表"

# general label for a controller, same as jr_simple_title(:books, :_label)
jr_simple_title(:books)
=> "我的書櫃"

# specify controller and action
jr_simple_title(:books, :index)
=> "書籍列表"

# controller with namespace
jr_simple_title("admin/sales", :index)
=> "銷售管理"
```
