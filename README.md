# Jurou / 翻譯蒟蒻

A collection of i18n related view helpers for Rails. Work in progress.

Lets say we have a model `Book`. `Book.genre` is a pre defined list of book genres, such as `fantasy, detective, romance, history, manga`. 

Most developers stick to English (at least the Latin alphabet) for such values. The thing is, your app more than often requires you to display them as `奇幻, 推理, 羅曼史, 歷史, 漫畫` or whatever your native language. 

Although there's the handy I18n API for localization, turns out this was still a messier process than I imagined. To keep things DRY I put together Jurou for myself.

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
      book:
        index: 書籍列表
        
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

Jurou will then generate the collection hash for the form helper, resulting in the following HTML:

```
<select>
  <option value="fantasy">奇幻</option>
  <option value="detective">推理</option> 
  <option value="romance">羅曼史</option>
  <option value="history">歷史</option> 
  <option value="manga">漫畫</option> 
</select>
```

### jr\_table\_row

Shorthand `jr_row` also available. 

```
# app/views/books/show.html.slim
table
  = jr_table_row :title, :book, @book.title
  = jr_table_row :author, :book, @book.author
  = jr_table_row :genre, :book, @book.genre, true
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

### jr\_attribute and jr\_vaule

You can use `jr_attribute` and  `jr_value`
 individually.
 
`jr_attribute` simply outputs the corresponding translation of the attribute. Shorthand `jr_attr` also available.

```
jr_attribute :author, :book
=> 作者
```

`jr_value` is only useful when you need to get the translation for the attribute value itself. 

```
jr_value :genre, :book, @book.genre
=> 推理
```

## jr\_page\_title

`jr_page_title` generates the page title based on the current controller and action. It will fall back to your app title when there is no match.

```
# GET /books/
= jr_page_title
=> 書籍列表 | 翻譯蒟蒻

# GET /movies
= jr_page_title
=> 翻譯蒟蒻
```
