# db/seeds.rb - Seed file for MyQuote application
puts "Seeding database..."

# ===== CATEGORIES =====
categories_data = [
  "Ethics", "Metaphysics", "Epistemology", "Logic",
  "Axiology", "Political Philosophy", "Aesthetics",
  "Philosophy of Mind", "Existentialism", "Stoicism"
]

categories = {}
categories_data.each do |name|
  cat = Category.find_or_create_by!(catname: name)
  categories[name] = cat
  puts "  Category: #{name}"
end

# ===== SOURCES =====
sources_data = [
  { key: "Socrates",    fname: "Socrates",   lname: nil,           byear: "470 BCE", dyear: "399 BCE", bio: "Classical Greek philosopher credited as the founder of Western philosophy. Known for the Socratic method of inquiry." },
  { key: "Aristotle",  fname: "Aristotle",  lname: nil,           byear: "384 BCE", dyear: "322 BCE", bio: "Ancient Greek philosopher and polymath. A student of Plato and teacher of Alexander the Great." },
  { key: "Plato",      fname: "Plato",      lname: nil,           byear: "428 BCE", dyear: "348 BCE", bio: "Athenian philosopher and student of Socrates. Founded the Academy in Athens." },
  { key: "Kant",       fname: "Immanuel",   lname: "Kant",        byear: "1724",    dyear: "1804",    bio: "German philosopher regarded as a central figure of modern philosophy. Known for the Critique of Pure Reason." },
  { key: "Nietzsche",  fname: "Friedrich",  lname: "Nietzsche",   byear: "1844",    dyear: "1900",    bio: "German philosopher known for his critiques of truth, morality, and religion. Author of Thus Spoke Zarathustra." },
  { key: "Beauvoir",   fname: "Simone",     lname: "de Beauvoir", byear: "1908",    dyear: "1986",    bio: "French existentialist philosopher and feminist theorist. Author of The Second Sex." },
  { key: "Aurelius",   fname: "Marcus",     lname: "Aurelius",    byear: "121 CE",  dyear: "180 CE",  bio: "Roman Emperor and Stoic philosopher. Author of the Meditations." },
  { key: "Descartes",  fname: "Rene",       lname: "Descartes",   byear: "1596",    dyear: "1650",    bio: "French philosopher and mathematician. Known for Cogito, ergo sum — I think, therefore I am." },
  { key: "Locke",      fname: "John",       lname: "Locke",       byear: "1632",    dyear: "1704",    bio: "English philosopher and physician. A founding figure of liberalism and the theory of natural rights." },
  { key: "Anonymous",  fname: "Anonymous",  lname: nil,           byear: nil,       dyear: nil,       bio: "Author unknown." }
]

sources = {}
sources_data.each do |s|
  src = Source.find_or_create_by!(fname: s[:fname], lname: s[:lname]) do |r|
    r.byear = s[:byear]; r.dyear = s[:dyear]; r.bio = s[:bio]
  end
  sources[s[:key]] = src
  puts "  Source: #{src.full_name}"
end

# ===== USERS =====
admin = User.find_or_initialize_by(email: "admin@myquotes.com")
if admin.new_record?
  admin.fname = "John"; admin.lname = "Jones"
  admin.password = "admin123"; admin.password_confirmation = "admin123"
  admin.is_admin = true; admin.status = "Active"
  admin.save!
  puts "  Admin created: admin@myquotes.com / admin123"
else
  puts "  Admin already exists."
end

vince = User.find_or_initialize_by(email: "vinceb@myemail.com")
if vince.new_record?
  vince.fname = "Vincent"; vince.lname = "Brown"
  vince.password = "vince123"; vince.password_confirmation = "vince123"
  vince.is_admin = false; vince.status = "Active"
  vince.save!
  puts "  User created: vinceb@myemail.com / vince123"
else
  puts "  User already exists."
end

# ===== QUOTES =====
# Dates ascending so homepage shows newest (Locke) first, oldest (Socrates) last
quotes_data = [
  {
    qtext:    "The unexamined life is not worth living.",
    qyear:    "399 BCE",
    qcom:     "Spoken at Socrates' trial — a timeless call for reflective living.",
    ispublic: true,
    source:   sources["Socrates"],
    owner:    vince,
    cats:     ["Ethics", "Existentialism"],
    date:     10.days.ago
  },
  {
    qtext:    "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
    qyear:    "350 BCE",
    qcom:     "A favourite reminder that character is built through consistent action.",
    ispublic: true,
    source:   sources["Aristotle"],
    owner:    vince,
    cats:     ["Ethics", "Axiology"],
    date:     9.days.ago
  },
  {
    qtext:    "Knowing yourself is the beginning of all wisdom.",
    qyear:    "350 BCE",
    qcom:     "One of the most enduring ideas from Aristotle.",
    ispublic: true,
    source:   sources["Aristotle"],
    owner:    vince,
    cats:     ["Epistemology", "Ethics"],
    date:     8.days.ago
  },
  {
    qtext:    "The measure of a man is what he does with power.",
    qyear:    nil,
    qcom:     nil,
    ispublic: true,
    source:   sources["Plato"],
    owner:    vince,
    cats:     ["Political Philosophy", "Ethics"],
    date:     7.days.ago
  },
  {
    qtext:    "Act only according to that maxim whereby you can at the same time will that it should become a universal law.",
    qyear:    "1785",
    qcom:     "Kant's categorical imperative — the foundation of deontological ethics.",
    ispublic: true,
    source:   sources["Kant"],
    owner:    vince,
    cats:     ["Ethics", "Logic"],
    date:     6.days.ago
  },
  {
    qtext:    "God is dead. God remains dead. And we have killed him.",
    qyear:    "1882",
    qcom:     "Nietzsche's declaration of the collapse of traditional moral frameworks.",
    ispublic: true,
    source:   sources["Nietzsche"],
    owner:    vince,
    cats:     ["Metaphysics", "Existentialism"],
    date:     5.days.ago
  },
  {
    qtext:    "One is not born, but rather becomes, a woman.",
    qyear:    "1949",
    qcom:     "De Beauvoir's core argument that gender is a social construction.",
    ispublic: true,
    source:   sources["Beauvoir"],
    owner:    vince,
    cats:     ["Political Philosophy", "Existentialism"],
    date:     4.days.ago
  },
  {
    qtext:    "You have power over your mind, not outside events. Realise this, and you will find strength.",
    qyear:    "170 CE",
    qcom:     "The essence of Stoic practice — focus only on what is within our control.",
    ispublic: true,
    source:   sources["Aurelius"],
    owner:    admin,
    cats:     ["Stoicism", "Ethics"],
    date:     3.days.ago
  },
  {
    qtext:    "I think, therefore I am.",
    qyear:    "1637",
    qcom:     "Descartes' foundational statement — the one truth he could not doubt.",
    ispublic: true,
    source:   sources["Descartes"],
    owner:    admin,
    cats:     ["Metaphysics", "Epistemology", "Philosophy of Mind"],
    date:     2.days.ago
  },
  {
    qtext:    "The end of law is not to abolish or restrain, but to preserve and enlarge freedom.",
    qyear:    "1689",
    qcom:     "Locke's argument that law exists to protect liberty, not restrict it.",
    ispublic: true,
    source:   sources["Locke"],
    owner:    admin,
    cats:     ["Political Philosophy", "Ethics"],
    date:     1.day.ago
  }
]

quotes_data.each do |qdata|
  q = Quote.find_or_initialize_by(qtext: qdata[:qtext], user: qdata[:owner])
  if q.new_record?
    q.qyear    = qdata[:qyear]
    q.qcom     = qdata[:qcom]
    q.ispublic = qdata[:ispublic]
    q.source   = qdata[:source]
    q.save!(validate: false)

    qdata[:cats].each do |cat_name|
      QuoteCategory.find_or_create_by!(quote: q, category: categories[cat_name])
    end

    q.update_columns(created_at: qdata[:date], updated_at: qdata[:date])
    puts "  Quote [#{qdata[:date].strftime('%d %b')}]: #{qdata[:qtext][0..55]}..."
  else
    puts "  Quote already exists: #{qdata[:qtext][0..55]}..."
  end
end

puts "\nSeeding complete!"
puts "  Admin:  admin@myquotes.com / admin123"
puts "  User:   vinceb@myemail.com / vince123"
puts "  Quotes: #{Quote.count} total"
