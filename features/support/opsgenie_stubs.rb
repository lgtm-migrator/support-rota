WebMock.stub_request(:get, %r(schedules/e71d500f-896a-4b28-8b08-3bfe56e1ed76))
  .to_return(
    status: 200,
    body: File.read(Rails.root.join('spec', 'fixtures', 'schedule_e71d500f.json')),
    headers: {"Content-Type" => "application/json"}
  )

WebMock.stub_request(:get, %r(schedules/b8e97704-0e9d-41b5-b27c-9d9027c83943))
  .to_return(
    status: 200,
    body: File.read(Rails.root.join('spec', 'fixtures', 'schedule_b8e97704.json')),
    headers: {"Content-Type" => "application/json"}
  )
