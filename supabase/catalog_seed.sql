-- Kerala Fresh Spices expanded catalogue
-- Review estimated prices and update them before accepting real customer orders.
-- Run this script in Supabase SQL Editor after backing up current product data.
-- Existing products are matched by name; new products are inserted only if absent.
-- Prices are stored in paise. Stock starts at 0 and variants are active but unavailable until stock is entered.

alter table public.products add column if not exists category text;
alter table public.products add column if not exists emoji text;

with catalogue(name, description, category, emoji) as (
  values
  ('Kerala Black Pepper','Bold, aromatic whole peppercorns.','Spices','🌶️'),
  ('Green Cardamom','Fragrant green cardamom pods.','Spices','🌿'),
  ('Cinnamon','Sweet and warming spice.','Spices','🪵'),
  ('Whole Cloves','Rich aroma and deep flavour.','Spices','🌰'),
  ('Turmeric Powder','Golden turmeric powder for everyday cooking.','Spices','🟡'),
  ('Dry Ginger','Traditional warming spice.','Spices','🫚'),
  ('Mustard Seeds','Essential for Indian cooking.','Spices','🟤'),
  ('Kerala Spice Mix','Aromatic blend for home cooking.','Spices','🧂'),
  ('Kerala Garam Masala','Aromatic Kerala-style garam masala.','Spices','🧂'),
  ('Fish Curry Masala','Spice blend for fish curry.','Spices','🌶️'),
  ('Chicken Masala','Spice blend for chicken dishes.','Spices','🍛'),
  ('Black Pepper Powder','Freshly ground black pepper.','Spices','🌶️'),
  ('Traditional Kerala Coconut Oil','Traditional coconut oil for cooking.','Coconut Products','🥥'),
  ('Virgin Coconut Oil','Virgin coconut oil.','Coconut Products','🥥'),
  ('Dried Coconut Slices','Dried coconut slices.','Coconut Products','🥥'),
  ('Kerala Banana Chips','Crispy Kerala-style banana chips.','Snacks','🍌'),
  ('Jackfruit Chips','Crispy jackfruit chips.','Snacks','🍈'),
  ('Kerala Mixture','Crunchy savoury Kerala mixture.','Snacks','🥨'),
  ('Tapioca Chips','Crunchy tapioca chips.','Snacks','🍘'),
  ('Achappam','Traditional Kerala rose cookies.','Snacks','🍪'),
  ('Dried Tapioca Pieces','Dried tapioca pieces for cooking.','Dried Foods','🍠'),
  ('Dried Anchovies','Dried anchovies, subject to courier acceptance.','Dried Foods','🐟'),
  ('Dried Prawns','Dried prawns, subject to courier acceptance.','Dried Foods','🦐'),
  ('Kerala Tea Powder','Tea powder for a strong cup of tea.','Tea & Coffee','🍵'),
  ('South Indian Filter Coffee Powder','Coffee powder for South Indian filter coffee.','Tea & Coffee','☕'),
  ('Kerala Mango Pickle','Traditional Kerala-style mango pickle.','Pickles & Sweets','🥭'),
  ('Kerala Halwa','Traditional Kerala halwa.','Pickles & Sweets','🍬')
)
insert into public.products(name, description, category, emoji, is_active)
select c.name, c.description, c.category, c.emoji, true
from catalogue c
where not exists (
  select 1 from public.products p where lower(trim(p.name)) = lower(trim(c.name))
);

update public.products p
set category = c.category, emoji = c.emoji, description = c.description
from (values
  ('Kerala Black Pepper','Spices','🌶️','Bold, aromatic whole peppercorns.'),
  ('Green Cardamom','Spices','🌿','Fragrant green cardamom pods.'),
  ('Cinnamon','Spices','🪵','Sweet and warming spice.'),
  ('Whole Cloves','Spices','🌰','Rich aroma and deep flavour.'),
  ('Turmeric Powder','Spices','🟡','Golden turmeric powder for everyday cooking.'),
  ('Dry Ginger','Spices','🫚','Traditional warming spice.'),
  ('Mustard Seeds','Spices','🟤','Essential for Indian cooking.'),
  ('Kerala Spice Mix','Spices','🧂','Aromatic blend for home cooking.')
) as c(name, category, emoji, description)
where lower(trim(p.name)) = lower(trim(c.name));

with variant_seed(product_name, pack_size, price_rupees) as (
  values
  ('Kerala Black Pepper','50 g',45::numeric),('Kerala Black Pepper','100 g',85),('Kerala Black Pepper','250 g',205),('Kerala Black Pepper','500 g',390),('Kerala Black Pepper','1 kg',750),
  ('Green Cardamom','50 g',140),('Green Cardamom','100 g',270),('Green Cardamom','250 g',680),('Green Cardamom','500 g',1340),('Green Cardamom','1 kg',2650),
  ('Cinnamon','50 g',30),('Cinnamon','100 g',55),('Cinnamon','250 g',135),('Cinnamon','500 g',260),('Cinnamon','1 kg',500),
  ('Whole Cloves','50 g',60),('Whole Cloves','100 g',110),('Whole Cloves','250 g',270),('Whole Cloves','500 g',530),('Whole Cloves','1 kg',1050),
  ('Turmeric Powder','100 g',35),('Turmeric Powder','250 g',65),('Turmeric Powder','500 g',130),('Turmeric Powder','1 kg',250),
  ('Dry Ginger','100 g',45),('Dry Ginger','250 g',95),('Dry Ginger','500 g',185),('Dry Ginger','1 kg',350),
  ('Mustard Seeds','100 g',25),('Mustard Seeds','250 g',45),('Mustard Seeds','500 g',85),('Mustard Seeds','1 kg',160),
  ('Kerala Spice Mix','100 g',50),('Kerala Spice Mix','250 g',115),('Kerala Spice Mix','500 g',220),('Kerala Spice Mix','1 kg',420),
  ('Kerala Garam Masala','100 g',70),('Kerala Garam Masala','250 g',165),('Kerala Garam Masala','500 g',320),('Kerala Garam Masala','1 kg',620),
  ('Fish Curry Masala','100 g',60),('Fish Curry Masala','250 g',140),('Fish Curry Masala','500 g',270),('Fish Curry Masala','1 kg',520),
  ('Chicken Masala','100 g',60),('Chicken Masala','250 g',140),('Chicken Masala','500 g',270),('Chicken Masala','1 kg',520),
  ('Black Pepper Powder','100 g',90),('Black Pepper Powder','250 g',215),('Black Pepper Powder','500 g',410),('Black Pepper Powder','1 kg',790),
  ('Traditional Kerala Coconut Oil','500 ml',180),('Traditional Kerala Coconut Oil','1 litre',340),('Traditional Kerala Coconut Oil','2 litres',660),
  ('Virgin Coconut Oil','100 ml',120),('Virgin Coconut Oil','200 ml',220),('Virgin Coconut Oil','500 ml',500),
  ('Dried Coconut Slices','100 g',55),('Dried Coconut Slices','250 g',125),('Dried Coconut Slices','500 g',240),
  ('Kerala Banana Chips','100 g',55),('Kerala Banana Chips','200 g',100),('Kerala Banana Chips','500 g',240),
  ('Jackfruit Chips','100 g',70),('Jackfruit Chips','200 g',130),('Jackfruit Chips','500 g',310),
  ('Kerala Mixture','200 g',75),('Kerala Mixture','400 g',140),('Kerala Mixture','1 kg',330),
  ('Tapioca Chips','100 g',50),('Tapioca Chips','200 g',95),('Tapioca Chips','500 g',225),
  ('Achappam','200 g',90),('Achappam','400 g',170),('Achappam','1 kg',400),
  ('Dried Tapioca Pieces','250 g',70),('Dried Tapioca Pieces','500 g',130),('Dried Tapioca Pieces','1 kg',240),
  ('Dried Anchovies','100 g',100),('Dried Anchovies','250 g',230),('Dried Anchovies','500 g',450),
  ('Dried Prawns','100 g',150),('Dried Prawns','250 g',360),('Dried Prawns','500 g',700),
  ('Kerala Tea Powder','250 g',110),('Kerala Tea Powder','500 g',210),('Kerala Tea Powder','1 kg',400),
  ('South Indian Filter Coffee Powder','200 g',130),('South Indian Filter Coffee Powder','500 g',300),('South Indian Filter Coffee Powder','1 kg',580),
  ('Kerala Mango Pickle','200 g',90),('Kerala Mango Pickle','400 g',165),('Kerala Mango Pickle','1 kg',390),
  ('Kerala Halwa','250 g',110),('Kerala Halwa','500 g',210),('Kerala Halwa','1 kg',400)
)
insert into public.product_variants(product_id, pack_size, price_paise, stock_quantity, is_active)
select p.id, v.pack_size, round(v.price_rupees * 100)::integer, 0, true
from variant_seed v
join public.products p on lower(trim(p.name)) = lower(trim(v.product_name))
where not exists (
  select 1 from public.product_variants pv
  where pv.product_id = p.id and pv.pack_size = v.pack_size
);

-- No stock is added automatically. Set real stock and verified prices in Admin.
select p.name, p.category, count(pv.id) as pack_options
from public.products p
left join public.product_variants pv on pv.product_id = p.id
group by p.id, p.name, p.category
order by p.category, p.name;
