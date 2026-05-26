# Upload places to Appwrite

Bulk-uploads **4 places per district** (256 documents) into the `places` collection.

## Before you run (Appwrite Console)

1. Open [Appwrite Console](https://cloud.appwrite.io) → project **Cholo BD** → Databases → `69ec314b0038beeb4258` → collection **`places`**.

2. Create these attributes if missing:

   | Attribute | Type |
   |-----------|------|
   | `name`, `name_bn`, `description`, `district_id`, `district_name` | String |
   | `visit_duration`, `best_time`, `opening_hours` | String |
   | `images`, `videos`, `tags` | String array |
   | `entry_fee`, `latitude`, `longitude`, `rating` | Float |
   | `is_free_entry` | Boolean |
   | `review_count` | Integer |

3. **Permissions** (required for the Flutter app):
   - **Read**: role **Any** (same as `districts`)
   - **Create/Update/Delete**: API key only (not public)

4. Optional: index on `district_id`.

5. Create an **API key** with Databases read + write. Export it:

   ```bash
   export APPWRITE_API_KEY='your_key_here'
   ```

## Run upload

```bash
cd tools/upload_places
dart pub get
export APPWRITE_API_KEY='your_key_here'
dart run upload_places.dart
```

## Add `videos` field in Appwrite (CLI)

Creates `videos` as a **String array** on the `places` collection (needs API key with `databases.write`):

```bash
export APPWRITE_API_KEY='your_key_here'
dart run upload_places.dart --add-videos-field
```

Create attribute and sync sample video URLs in one go:

```bash
dart run upload_places.dart --add-videos-field --sync-media
```

## Sync videos on existing places

After the `videos` attribute exists:

```bash
dart run upload_places.dart --sync-media
```

## Update district `place_count` (optional)

```bash
dart run upload_places.dart --update-counts
```

## Re-run

The script skips documents that already exist (409). Delete places in Console or change document IDs to re-upload.
