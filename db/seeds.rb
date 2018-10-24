# frozen_string_literal: true

# This file should contain all the record creation needed to
# seed the database with its default values.
# The data can then be loaded with the rails db:seed command
# (or created alongside the database with db:setup).
User.create(
  [
    { name: 'Ram Prasad Reddy',
      title: 'Software Engineer',
      email: 'ram@gmail.com',
      password: '12345678' },
    { name: 'Vanshika Dasari',
      title: 'IAS Officer',
      email: 'vanshika@gmail.com',
      password: '12345678' },
    { name: 'Aruna Maddi',
      title: 'Teacher',
      email: 'aruna@gmail.com',
      password: '12345678' },
    { name: 'Gurunadh Maddi',
      title: 'Mechanical Engineer',
      email: 'gurunadh@gmail.com',
      password: '12345678' }
  ]
)

Board.create(
  [
    { title: 'Rams board',
      agenda: 'Rams Retro',
      user: User.find_by_email('ram@gmail.com') },
    { title: 'Vanshikas board',
      agenda: 'Vanshikas Retro',
      user: User.find_by_email('vanshika@gmail.com') },
    { title: 'Arunas board',
      agenda: 'Arunas Retro',
      user: User.find_by_email('aruna@gmail.com') },
    { title: 'Gurunadhs board',
      agenda: 'Gurunadhs Retro',
      user: User.find_by_email('gurunadh@gmail.com') },
    { title: 'Ram and Vanshikas board',
      agenda: 'Ram and Vanshikas Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('vanshika@gmail.com').id] },
    { title: 'Ram and Arunas board',
      agenda: 'Ram and Arunas Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('aruna@gmail.com').id] },
    { title: 'Ram and Gurunadhs board',
      agenda: 'Ram and Gurunadhs Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('gurunadh@gmail.com').id] },
    { title: 'Ram, Vanshika and Arunas board',
      agenda: 'Ram, Vanshika and Arunas Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('vanshika@gmail.com').id,
                         User.find_by_email('aruna@gmail.com').id] },
    { title: 'Ram, Aruna and Gurunadhs board',
      agenda: 'Ram, Aruna and Gurunadhs Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('gurunadh@gmail.com').id,
                         User.find_by_email('aruna@gmail.com').id] },
    { title: 'Ram, Vanshika and Gurunadhs board',
      agenda: 'Ram, Vanshika and Gurunadhs Retro',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('vanshika@gmail.com').id,
                         User.find_by_email('gurunadh@gmail.com').id] },
    { title: 'Common Board',
      agenda: 'General Discussion with everyone',
      user: User.find_by_email('ram@gmail.com'),
      collaborator_ids: [User.find_by_email('vanshika@gmail.com').id,
                         User.find_by_email('aruna@gmail.com').id,
                         User.find_by_email('gurunadh@gmail.com').id] }
  ]
)
