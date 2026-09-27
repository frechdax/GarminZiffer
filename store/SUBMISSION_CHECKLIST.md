# Connect IQ Store Submission Checklist

## Automated
- [x] Watch face builds for Venu 3
- [x] Watch face builds for Venu 3S
- [x] Watch face builds for vívoactive 5
- [x] Multi-device .iq export workflow
- [x] German and English app name
- [x] German and English store descriptions
- [x] No additional permissions in manifest
- [x] Store-safe app name: Blush Dial

## Before submitting
- [ ] Download the latest Blush-Dial.iq artifact from GitHub Actions
- [ ] Sign in to the Garmin Connect IQ Developer Dashboard
- [ ] Create the first app submission and upload Blush-Dial.iq
- [ ] Let Garmin validate the binary
- [ ] Add the English and German descriptions from STORE_LISTING.md
- [ ] Upload store icon (500 x 500 px, sRGB)
- [ ] Upload screenshots of the watch face
- [ ] Optional: upload a hero image (1440 x 720 px)
- [ ] Preview the listing
- [ ] Submit for Garmin review

## Store asset guidance
Garmin recommends:
- Store app icon: 500 x 500 px, sRGB
- Keep about 10 px padding around the icon
- Do not use a black or transparent icon background
- Avoid descriptive text in the icon
- Do not use Garmin branding in the icon
- For watch faces, a preview of the watch face often works well as the store icon
- Hero image: 1440 x 720 px

## Important
The repository keeps the application ID unchanged. This ensures the Store package remains the same Connect IQ application as development continues.

The export workflow supports a persistent developer key via the GitHub Actions secret:
GARMIN_DEVELOPER_KEY_B64

If that secret is absent, CI creates a temporary signing key so the package can still be validated and tested.
