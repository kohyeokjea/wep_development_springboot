package me.ko.springbootdeveloper.service;

import lombok.RequiredArgsConstructor;
import me.ko.springbootdeveloper.domain.RefreshToken;
import me.ko.springbootdeveloper.repository.RefreshTokenRepository;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class RefreshTokenService {
    private final RefreshTokenRepository refreshTokenRepository;

    public RefreshToken findByRefreshToken(String refreshToken) {
        return refreshTokenRepository.findByRefreshToken(refreshToken)
                .orElseThrow(() -> new IllegalArgumentException("unexpected token"));
    }
}
