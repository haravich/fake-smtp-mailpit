# Simulating Email with a Fake SMTP Server Using Docker

[![fake-smtp-mailpit build](https://github.com/haravich/fake-smtp-mailpit/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/haravich/fake-smtp-mailpit/actions/workflows/docker-publish.yml) ![Docker pulls](https://img.shields.io/docker/pulls/haravich/fake-smtp-mailpit)

## Introduction

In the realm of software testing, having a reliable environment to simulate email interactions is crucial. Docker, a powerful containerization technology, offers a seamless solution for creating and managing isolated environments. This tutorial will guide you through setting up a fake SMTP server using a Docker image, allowing you to mimic email exchanges for testing purposes.

## Prerequisites

- Docker installed on your machine. If not installed, you can download it from [Docker's official website](https://www.docker.com/get-started).

## Step 1: Obtain the Docker Image

Pull the "FakeSMTP" Docker image, a popular choice for emulating SMTP interactions:

```bash
docker pull haravich/fake-smtp-mailpit
```

## Step 2: Run the Fake SMTP Server

Launch the fake SMTP server container, exposing ports 1025, 1110 and 8025:

```bash
docker run -d -p 1025:1025 -p 1110:1110 -p 8025:8025 haravich/fake-smtp-mailpit
```

## Step 3: Access the Web Interface

Open your web browser and navigate to http://localhost:8025 to access the fake SMTP server's web interface. Here, you can monitor incoming email traffic.

## Step 4: Send Test Emails

Configure your application's SMTP settings to use the IP address of the machine running the Docker container, and set port 1025 for the SMTP server. Test emails sent from your application will be captured by the fake SMTP server and displayed in the web interface.

## Step 5: Analyze and Verify

Use the web interface to analyze email interactions and ensure that your application behaves as expected. This controlled testing environment prevents interference with real email systems.

## Conclusion
Creating a fake SMTP server using Docker enhances your email-related testing capabilities. Docker's isolation and port mapping features enable realistic email simulation without affecting real email infrastructure. With the web interface, you can efficiently monitor and validate email interactions, streamlining your testing workflow and enhancing your software's reliability.

## License

This project is licensed under the [MIT LICENSE](LICENSE).
See the [LICENSE](LICENSE) file for more details.

## Source Repository

The source code for this project is available on [GitHub](https://github.com/haravich/fake-smtp-mailpit).

## Credits

### Mailpit
Mailpit is a small, fast, low memory, zero-dependency, multi-platform email testing tool & API for developers.

It acts as an SMTP server, provides a modern web interface to view & test captured emails, and includes an API for automated integration testing.

Mailpit was originally inspired by MailHog which is no longer maintained and hasn't seen active development or security updates for a few years now.

The mailpit golang file used in this Dockerfile is created and maintained by [Ralph Slooten](https://github.com/axllent). The source code can be found in [Github](https://github.com/axllent/mailpit).

The copy of LICENSE has been included in this repo as well. The original LICENSE can be found in [Mailpit](https://github.com/axllent/mailpit/blob/develop/LICENSE)
