-- Create vendors table if it doesn't exist
CREATE TABLE IF NOT EXISTS vendors (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  company text,
  type text,
  phone text,
  email text,
  website text,
  notes text,
  created_at timestamptz DEFAULT now()
);
ALTER TABLE vendors DISABLE ROW LEVEL SECURITY;
GRANT ALL ON vendors TO anon;

-- Step 1: Insert vendor-type contacts into vendors table
INSERT INTO vendors (id, name, type, phone, email)
VALUES
('d19646bc-0e43-4e45-b56b-35b7ee941474', 'Abu Saleh Mohammad Abdullah Abu Saleh Mohammad Abdullah', 'other', '', ''),
('7ed9ac5e-f96f-4b7d-96d3-728f56927a11', 'Down to Earth', 'other', '9083194434', 'd2efarms@gmail.com'),
('d047a77f-5724-4e91-8c37-22258b107f0a', 'J & D WOOD, INC', 'other', '(910) 628-9000', 'sales@janddwood.com'),
('9e655cf3-4fcd-41dc-a89c-95f66e5285ec', 'Jamie Isaacs', 'other', '6313324665', 'info@jamieissacsphoto.com'),
('3c6de987-3d77-498f-82b0-f466e66f8075', 'Johnson Horse Transportation DJ Johnson', 'transport', '6104887220', ''),
('237c896a-642b-4efa-b2c3-737f1a3694f8', 'Joshua Smith', 'farrier', '9732194118', ''),
('7c6eda06-5c96-4faf-92ca-7fa50ee05604', 'Landscape Materials Inc', 'other', '(908) 252-1550', 'www.lmitopsoil@yahoo.com'),
('9e308ba3-fca4-44dd-b6bb-a703c4a4a73b', 'MDV HORSE TRANSPORT', 'transport', '2035615641', ''),
('61900b62-d1d6-4069-ad55-188b753cc352', 'Nicole  Jochec', 'veterinarian', '(908) 832-5484', 'info@runningsequine.com'),
('7569b544-b416-4318-a14d-1ee3daa0cfe4', 'Rina Dachhepati', 'other', '', ''),
('62a20e1a-57f7-4922-a42e-3a121a78bbdc', 'Sergeantsville Grain (Brenda) Contact person is Brenda', 'feed', '609-397-0807', ''),
('0f91fc08-0c73-4aa1-8143-500e1e136e03', 'Travis Bowers', 'veterinarian', '', '')
ON CONFLICT DO NOTHING;

-- Step 2: Remove vendor-type contacts from clients
DELETE FROM clients WHERE lower(trim(name)) = lower('Abu Saleh Mohammad Abdullah Abu Saleh Mohammad Abdullah');
DELETE FROM clients WHERE lower(trim(name)) = lower('Down to Earth');
DELETE FROM clients WHERE lower(trim(name)) = lower('J & D WOOD, INC');
DELETE FROM clients WHERE lower(trim(name)) = lower('Jamie Isaacs');
DELETE FROM clients WHERE lower(trim(name)) = lower('Johnson Horse Transportation DJ Johnson');
DELETE FROM clients WHERE lower(trim(name)) = lower('Joshua Smith');
DELETE FROM clients WHERE lower(trim(name)) = lower('Landscape Materials Inc');
DELETE FROM clients WHERE lower(trim(name)) = lower('MDV HORSE TRANSPORT');
DELETE FROM clients WHERE lower(trim(name)) = lower('Nicole  Jochec');
DELETE FROM clients WHERE lower(trim(name)) = lower('Rina Dachhepati');
DELETE FROM clients WHERE lower(trim(name)) = lower('Sergeantsville Grain (Brenda) Contact person is Brenda');
DELETE FROM clients WHERE lower(trim(name)) = lower('Travis Bowers');

-- Step 3: Remove duplicate clients (keep one per name)
DELETE FROM clients
WHERE id NOT IN (
  SELECT DISTINCT ON (lower(trim(name))) id
  FROM clients
  ORDER BY lower(trim(name)),
           (char_length(coalesce(phone,'')) + char_length(coalesce(email,'')) + char_length(coalesce(roles,''))) DESC
);

-- Step 4: Add Caroline Johnston as trainer (update if exists, insert if not)
INSERT INTO clients (id, name, roles, phone, email, city, state, archived)
VALUES (gen_random_uuid(), 'Caroline Johnston', 'trainer', '', '', '', '', false)
ON CONFLICT DO NOTHING;

-- If she already exists, update her role
UPDATE clients SET roles = 'trainer' WHERE lower(trim(name)) LIKE '%caroline%johnston%';
