# Happy Company

---

Happy Company is a really simple Ruby on Rails application that will help you to measure happiness in your company.

## Roles

### Regular user

Can register, log in, edit profile and answer a question about how he/she feels about past day at work.

### Administrator

Admin can mange users and groups. He can also generate statistics for groups, parent groups and users

## Answers

There is only one question "Are you happy today?" with four possible answers:
- Yes, I'm very happy about this day :D (score 3)
- Yes, this day was nice :) (score 2)
- No, it was an average day for me :/ (score 1)
- No, this day was a big disappointment :( (score 0)

## Groups

Administrator can create regular group or parent group. User can be only assigned to regular group. Parent groups are used for statistics purposes. For example you can create a structure like this:

Legend: PG (name) - parent group; G (name) - regular group; name - user

-PG(Rooms)
    - G (200)
        - Irek
        - Tomek
        - Arek
    - G (201)
        - Bartek
        - Rafał
    - G (202)
        - Błażej
        - Szymon
    - G (203)
        - Darek
        - Grzegorz

-PG (Positions)
    - G (Developers)
        - Irek
        - Tomek
        - Błażej
        - Bartek
        - Szymon
    - G (Designers)
        - Arek
        - Rafał
    - G (Marketing)
        - Darek
        - Grzegorz

- PG (Teams)
    - G (Mariachi)
        - Irek
        - Tomek
        - Arek
    - G (Lumberjacks)
        - Bartek
        - Rafał
        - Błażej
        - Szymon

## Statistics

Can be displayed for a specific period of time (last week, last month) or custom range. Admin can choose if he/she want to display only a specific person, whole group or few groups that are nested within parent group.

---

### Dependencies

As usual you can find all dependencies in Gemfile but the most important gems are: ActiveAdmin, Haml and Devise and Postgresql (of course database engine can be changed for whatever you want).

---

### Credits

Supported by Selleo web &amp; mobile software development house - [http://selleo.com](http://selleo.com)

### License

The MIT license

Copyright &copy; 2013 [Ireneusz Skrobiś](https://twitter.com/ireneuszskrobis)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.