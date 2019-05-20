# Magento prerequisites and configurations

See: [https://devdocs.magento.com/guides/v2.3/install-gde/prereq/prereq-overview.html](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/prereq-overview.html)

# Instruction

```bash
docker-compose up -d
```

# Directory structure

```yml
- root/
  - magento2/ # Storing Magento source code
  - nginx/
    - magento.conf # NGINX configuration file for Magento server
  - php/
    - conf.d/
      - php.ini # PHP configuration file
      - www.conf # PHP-FPM configuration file
    - composer.auth.json # Storing credentials for Composer private package of Magento
    - docker-entrypoint.sh # Docker entrypoint file
    - Dockerfile # Custom PHP-FPM image
  - .env.sample # A sample of .env file
  - docker-compose.yml
```

# Note

- Magento 2 Setup Wizard อาจจะแสดง installation progress ค้างอยู่ที่จุดใดจุดหนึ่ง ไม่ครบ 100% แต่ไม่ได้หมายความว่า installation ไม่สมบูรณ์ ให้อ่าน file `<magento_root_directory>/var/log/install.log` ประกอบ หากเจอคำว่า `'SUCCESS'` แปลว่า install เสร็จแล้ว ให้กลับไปหน้า home ของ website ได้เลย

- Admin ต้อง login ผ่าน admin unique URL ที่กำหนดไว้ระหว่างการ setup ไม่สามารถ login ผ่านหน้า login ของ customer ได้ ถ้า login ผ่านหน้าของ customer เมื่อ submit แล้วจะขึ้น error ว่า `Invalid form key. Please, refresh the page.`

- เมื่อ login เข้าหน้า dashboard ได้แล้ว อาจเจอแจ้งเตือนที่ส่วนบนสุดของ page ว่า `One or more indexers are invalid. Make sure your Magento cron job is running.` แก้โดยการ run mangento command `magento indexer:reindex`

- อาจเจออีกแจ้งเตือนนึงว่า `One or more of the Cache Types are invalidated: Configuration, Page Cache. Please go to Cache Management and refresh cache types` ให้ไปที่ Cache management page แล้ว click `Flush Magento Cache`