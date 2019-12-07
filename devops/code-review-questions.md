
# Code Review Questions

This follows on from the [[goals of a code review|code review goals]].

## Grow the Developer | Increase Code Quality

Just looking at code is a poor way to conduct a **code review** because you miss an opportunity to grow the developer.

- what components are likely to be reused (multiply)
- what use cases will be reused
- how have you facilitated (will you facilitate) both reuse and multiplication
- what use cases currently touch (can now touch or could touch in the future) this code


## Reuse vs Multiplication

Reuse is well understood but the concept of multiplication is too often ignored.

**Multiplication is the twin of reuse.**

### Downloading files from an S3 bucket

If a DevOps engineer writes software to download files from an S3 bucket, their design may facilitate

- downloading files from Git, GoogleDrive and other remote filesystems
- uploading files to an S3 bucket
- downloading very large files that may already be present (merging)
- downloading files as any one of 50 IAM users

How something is written **today** speaks volumes about what is **expected to multiply** and/or **be reused** tomorrow.

