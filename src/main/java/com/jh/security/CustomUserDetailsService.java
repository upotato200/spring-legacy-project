package com.jh.security;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.jh.vo.UserVO;

/**
 * Spring Security 인증 — tbl_user 기반
 * uid, upw, role, enabled 컬럼을 사용한다.
 */
@Service("customUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    @Inject
    private SqlSession session;

    @Override
    public UserDetails loadUserByUsername(String uid) throws UsernameNotFoundException {
        UserVO userVO = session.selectOne("com.jh.mapper.UserMapper.loadByUid", uid);

        if (userVO == null) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + uid);
        }

        List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
        authorities.add(new SimpleGrantedAuthority(userVO.getRole()));

        return new User(
            userVO.getUid(),
            userVO.getUpw(),
            userVO.getEnabled() == 1,  // enabled
            true,                       // accountNonExpired
            true,                       // credentialsNonExpired
            true,                       // accountNonLocked
            authorities
        );
    }
}
