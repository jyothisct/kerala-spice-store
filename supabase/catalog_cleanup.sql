-- Run this small cleanup query in Supabase SQL Editor.
-- It hides legacy duplicate products that are not part of the approved catalogue.
-- Existing orders remain intact because records are deactivated, not deleted.

update public.products
set is_active = false
where lower(trim(name)) in (
  'coconut oil',
  'dried tapioca pieces',
  'turmeric powder',
  'mustard seeds',
  'dried coconut slices'
);

-- Show any active products that may be duplicate coconut oil entries.
select name, category, is_active
from public.products
where lower(name) like '%coconut oil%'
order by name;
