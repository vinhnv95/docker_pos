# webpos-client-omc-2.0-testcase
Test Case

## Run Test
### Acceptance
After `ssh` to docker container `mftf` with username `www-data`
```sh
docker exec -u www-data -it dockermftf_mftf_1 /bin/bash
cd dev/tests/acceptance
vendor/bin/robo generate:tests
vendor/bin/codecept run
# Show Report
cp tests/_output/allure-results/* /allure-results/
```
