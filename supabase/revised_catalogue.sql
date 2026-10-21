-- Kerala Fresh Spices: apply the owner's revised pack-size list.
-- Run once in Supabase SQL Editor. Prices remain provisional estimates.
-- Existing product records are deactivated rather than deleted to preserve order history.

alter table public.products add column if not exists category text;
alter table public.products add column if not exists emoji text;

-- Rename dried tapioca product to the requested display name.
update public.products set name = 'Dry Tapioca', description = 'Dry tapioca pieces for cooking.', category = 'Dried Foods', emoji = '🍠'
where lower(trim(name)) = lower(trim('Dried Tapioca Pieces'))
  and not exists (select 1 from public.products where lower(trim(name)) = lower(trim('Dry Tapioca'));

-- Deactivate products explicitly removed from the catalogue.
update public.products set is_active = false
where lower(trim(name)) in ('turmeric powder','mustard seeds','dried coconut slices');

-- Ensure required products exist.
with catalogue(name, description, category, emoji) as (
 values
 ('Kerala Black Pepper','Bold, aromatic raw whole peppercorns.','Spices','🌶️'),
 ('Green Cardamom','Fragrant green cardamom pods.','Spices','🌿'),
 ('Cinnamon','Sweet and warming spice.','Spices','🪵'),
 ('Whole Cloves','Rich aroma and deep flavour.','Spices','🌰'),
 ('Dry Ginger','Traditional warming spice.','Spices','🫚'),
 ('Kerala Spice Mix','Aromatic blend for home cooking.','Spices','🧂'),
 ('Kerala Garam Masala','Aromatic Kerala-style garam masala.','Spices','🧂'),
 ('Fish Curry Masala','Spice blend for fish curry.','Spices','🌶️'),
 ('Chicken Masala','Spice blend for chicken dishes.','Spices','🍛'),
 ('Black Pepper Powder','Ground black pepper.','Spices','🌶️'),
 ('Traditional Kerala Coconut Oil','Traditional coconut oil for cooking.','Coconut Products','🥥'),
 ('Virgin Coconut Oil','Virgin coconut oil.','Coconut Products','🥥'),
 ('Kerala Banana Chips','Crispy Kerala-style banana chips.','Snacks','🍌'),
 ('Jackfruit Chips','Crispy jackfruit chips.','Snacks','🍈'),
 ('Kerala Mixture','Crunchy savoury Kerala mixture.','Snacks','🥨'),
 ('Tapioca Chips','Crunchy tapioca chips.','Snacks','🍘'),
 ('Dry Tapioca','Dry tapioca pieces for cooking.','Dried Foods','🍠'),
 ('Achappam','Traditional Kerala rose cookies.','Snacks','🍪'),
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
where not exists (select 1 from public.products p where lower(trim(p.name)) = lower(trim(c.name)));

-- Mark only the selected products as active and update their categories.
update public.products p set is_active = true
where lower(trim(p.name)) in (
 'kerala black pepper','green cardamom','cinnamon','whole cloves','dry ginger',
 'kerala spice mix','kerala garam masala','fish curry masala','chicken masala',
 'black pepper powder','traditional kerala coconut oil','virgin coconut oil',
 'kerala banana chips','jackfruit chips','kerala mixture','tapioca chips',
 'dry tapioca','achappam','dried anchovies','dried prawns','kerala tea powder',
 'south indian filter coffee powder','kerala mango pickle','kerala halwa'
);
update public.products set is_active = false
where lower(trim(name)) in ('dried tapioca pieces','turmeric powder','mustard seeds','dried coconut slices');

-- Deactivate all existing variants first; the selected sizes below are reactivated.
update public.product_variants set is_active = false
where product_id in (select id from public.products);

with variant_seed(product_name, pack_size, price_rupees) as (
 values
 ('Kerala Black Pepper','100 g',85::numeric),('Kerala Black Pepper','250 g',205),('Kerala Black Pepper','500 g',390),('Kerala Black Pepper','1 kg',750),
 ('Green Cardamom','50 g',140),('Green Cardamom','100 g',270),('Green Cardamom','250 g',680),
 ('Cinnamon','50 g',30),('Cinnamon','100 g',55),('Cinnamon','250 g',135),
 ('Whole Cloves','50 g',60),('Whole Cloves','100 g',110),('Whole Cloves','250 g',270),
 ('Dry Ginger','100 g',45),('Dry Ginger','250 g',95),
 ('Kerala Spice Mix','100 g',50),('Kerala Spice Mix','250 g',115),('Kerala Spice Mix','500 g',220),
 ('Kerala Garam Masala','100 g',70),('Kerala Garam Masala','250 g',165),
 ('Fish Curry Masala','100 g',60),('Fish Curry Masala','250 g',140),
 ('Chicken Masala','100 g',60),('Chicken Masala','250 g',140),
 ('Black Pepper Powder','100 g',90),('Black Pepper Powder','250 g',215),
 ('Traditional Kerala Coconut Oil','500 ml',180),('Traditional Kerala Coconut Oil','1000 ml',340),
 ('Virgin Coconut Oil','500 ml',500),('Virgin Coconut Oil','1000 ml',950),
 ('Kerala Banana Chips','200 g',100),('Kerala Banana Chips','500 g',240),('Kerala Banana Chips','1 kg',460),
 ('Jackfruit Chips','200 g',130),('Jackfruit Chips','500 g',310),('Jackfruit Chips','1 kg',600),
 ('Kerala Mixture','200 g',75),('Kerala Mixture','500 g',180),
 ('Tapioca Chips','200 g',95),('Tapioca Chips','500 g',225),('Tapioca Chips','1 kg',430),
 ('Dry Tapioca','1 kg',240),('Dry Tapioca','3 kg',690),('Dry Tapioca','5 kg',1100),
 ('Achappam','200 g',90),('Achappam','500 g',210),('Achappam','1 kg',400),
 ('Dried Anchovies','100 g',100),('Dried Anchovies','250 g',230),('Dried Anchovies','500 g',450),
 ('Dried Prawns','100 g',150),('Dried Prawns','250 g',360),('Dried Prawns','500 g',700),
 ('Kerala Tea Powder','250 g',110),('Kerala Tea Powder','500 g',210),('Kerala Tea Powder','1 kg',400),
 ('South Indian Filter Coffee Powder','200 g',130),('South Indian Filter Coffee Powder','500 g',300),
 ('Kerala Mango Pickle','200 g',90),('Kerala Mango Pickle','400 g',165),
 ('Kerala Halwa','250 g',110),('Kerala Halwa','500 g',210)
)
insert into public.product_variants(product_id, pack_size, price_paise, stock_quantity, is_active)
select p.id, v.pack_size, round(v.price_rupees * 100)::integer, 0, true
from variant_seed v
join public.products p on lower(trim(p.name)) = lower(trim(v.product_name))
on conflict (product_id, pack_size) do update
set price_paise = excluded.price_paise, is_active = true;

-- Show the final active catalogue and number of pack options.
select p.name, p.category, string_agg(pv.pack_size, ', ' order by pv.pack_size) as pack_sizes
from public.products p
left join public.product_variants pv on pv.product_id = p.id and pv.is_active = true
where p.is_active = true
group by p.id, p.name, p.category
order by p.category, p.name;
